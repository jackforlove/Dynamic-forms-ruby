module Excel
  class Main
    # Excel::Main.get_content_from_excel(file, file_name, skip_row: 0, &proc)
    def self.get_content_from_excel(file, file_name, skip_row: 0, &proc)
      unless file.present?
        return
      end

      if file_name.match(/.xlsx/)
        contents = RubyXL::Parser.parse(file)
        sheet1 = contents.worksheets[0]
      else
        contents = Spreadsheet.open(file)
        sheet1 = contents.worksheet 0
      end

      index = 0
      sheet1.each do |row|
        index += 1
        if index <= skip_row
          next
        end

        arr = []
        if row
          if file_name.match(/.xlsx/)
              if row.cells.compact.present?
                row.cells.each { |cell|
                    if cell
                      val = cell.value

                      arr << val
                    else
                      arr << nil
                    end
                }
              end
          else
            arr = row
          end

          proc.call(arr)
        end
      end
    end


    def self.export_xls(collections, sheet_name, header, &block)
      file = Tempfile.new
      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet name: sheet_name
      skip_row = 1
      sheet1.row(0).concat header

      collections.each do |collect|
        block.call(sheet1, skip_row, collect)
      end

      book.write file

      file
    end
  end
end