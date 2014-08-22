class ReportPdf < Prawn::Document
  def initialize(report)
    super({top_margin: 0, left_margin: 30, right_margin: 0, page_size: 'A4', page_layout: :landscape })
    @report = report


    content_report
    print_qr_code(qr_content)
    image_descrpition
    image_show
    link_addres
    link_help
  end




  def content_report

      draw_text "REPORT NO", :at=> [20,340],size: 11, style: :bold
      fill_color "#000000"
      draw_text ":  #{@report.reportnumber}", :at=> [160,340],size: 11, style: :normal


      draw_text "DATE", :at=> [20,310],size: 11, style: :bold
      fill_color "#000000"
      draw_text ":  #{@report.updated_at.strftime("%d/%b/%Y")}", :at=> [160,310],size: 11, style: :normal


      draw_text "REFERENCE", :at=> [20,280],size: 11, style: :bold
      fill_color "#000000"
      draw_text ":  #{@report.reference}", :at=> [160,280],size: 11, style: :normal


      draw_text "SPECIES", :at=> [20,250],size: 11, style: :bold
      fill_color "#000000"
      draw_text ":  #{@report.species.capitalize}", :at=> [160,250],size: 11, style: :normal


      draw_text "VARIETY", :at=> [20,220],size: 11, style: :bold
      fill_color "#000000"
      draw_text ":  #{@report.variety.capitalize}", :at=> [160,220],size: 11, style: :normal


      draw_text "WEIGHT", :at=> [20,190],size: 11, style: :bold
      fill_color "#000000"
      draw_text ":  #{@report.weight} cts", :at=> [160,190],size: 11, style: :normal


      draw_text "DIMENSION", :at=> [20,160],size: 11, style: :bold
      fill_color "#000000"
      draw_text ":  #{@report.dimension} mm", :at=> [160,160],size: 11, style: :normal

      draw_text "SHAPE & CUT", :at=> [20,130],size: 11, style: :bold
      fill_color "#000000"
      draw_text ":  #{@report.shapecut.capitalize}", :at=> [160,130],size: 11, style: :normal

      draw_text "COLOUR", :at=> [20,100],size: 11, style: :bold
      fill_color "#000000"
      draw_text ":  #{@report.colour.capitalize}", :at=> [160,100],size: 11, style: :normal


      draw_text "COMMENTS", :at=> [20, 70],size: 11, style: :bold
      fill_color "#000000"
        text_box ":  #{@report.comments.capitalize}", :at=> [160,70],size: 11, style: :normal, :width => 220
  end

def image_show
    id_sample = Rails.root + @report.image.path(:medium)
    image id_sample, at: [540, 400], height: 90, width: 130
    move_down 20
end


  def image_descrpition
      fill_color "#000000"
      text_box "This photo is for representational purpose only. Color and/or size may may vary from original.", :at=> [495, 300],size: 8, style: :normal, :width => 220, align: :center
  end

  def link_help
      fill_color "#000000"
      text_box "Find Help go to:", :at=> [368, 105],size: 8, style: :normal, :width => 220, align: :center
  end

  def link_addres
      fill_color "#000000"
      text_box "www.emteemgemlab.lk", :at=> [368, 97],size: 8, style: :normal, :width => 220, align: :center
  end



  # The default size for QR Code modules is 1/72 in
  DEFAULT_DOTSIZE = 2

  def qr_content
  
    move_down 385

    "http://0.0.0.0:3000/ireports/#{@report.id}-#{@report.reference}"
  end

  def print_qr_code(content, *options)
    opt = options.extract_options!
    qr_version = 0
    level = opt[:level] || :l
    extent = opt[:extent]
    dot_size = DEFAULT_DOTSIZE
    begin
      qr_version +=1
      qr_code = RQRCode::QRCode.new(content, :size=>qr_version, :level=>level)

      dot_size = extent/(8+qr_code.modules.length) if extent
      render_qr_code(qr_code, :dot=>dot_size, :pos=>opt[:pos], :stroke=>opt[:stroke], :align=>opt[:align])
    rescue RQRCode::QRCodeRunTimeError
      if qr_version <40
        retry
      else
        raise
      end
    end
  end

  def render_qr_code(qr_code, *options)
    opt = options.extract_options!
    dot = DEFAULT_DOTSIZE
    extent= opt[:extent] || (8+qr_code.modules.length) * dot
    stroke = (opt.has_key?(:stroke) && opt[:stroke].nil?) || opt[:stroke]
    foreground_color = opt[:foreground_color] || '000000'
    background_color = opt[:background_color] || 'FFFFFF'
    stroke_color = opt[:stroke_color] || 'FFFFFF'

    pos = opt[:pos] ||[440, cursor]

    align = opt[:align]
    case(align)
    when :center
      pos[0] = (@bounding_box.right / 2) - (extent / 2) 
    when :right
      pos[0] = @bounding_box.right - extent
    when :left
      pos[0] = 0;
    end

    stroke_color stroke_color
    fill_color background_color

    bounding_box pos, :width => extent, :height => extent do |box|
      fill_color foreground_color

      if stroke
        stroke_bounds
      end

      pos_y = 4*dot +qr_code.modules.length * dot

      qr_code.modules.each_index do |row|
        pos_x = 4*dot
        dark_col = 0
        qr_code.modules.each_index do |col|
          move_to [pos_x, pos_y]
          if qr_code.dark?(row, col)
            dark_col = dark_col+1
          else
            if (dark_col>0)
              fill { rectangle([pos_x - dark_col*dot, pos_y], dot*dark_col, dot) }
              dark_col = 0
            end
          end
          pos_x = pos_x + dot
        end
        if (dark_col > 0)
          fill { rectangle([pos_x - dark_col*dot, pos_y], dot*dark_col, dot) }
        end
        pos_y = pos_y - dot
      end
    end
  end





end