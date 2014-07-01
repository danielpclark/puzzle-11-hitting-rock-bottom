class Cave
	attr_reader :stop_point
	attr_accessor :grid

	def initialize(file)
		@stop_point = 0
		@grid = []
		File.readlines(file).each { |line|
			if !!(line[0] =~ /[0-9]/)
				@stop_point = line.to_i
			elsif not line.strip.empty?
				@grid << Array( line.strip.split('') )
			end
		}
	end

	def down_count_char(char_var = "~")
		@output = []
		(0..@grid[0].length).each do |col_index|
			has_char = false
			count = 0
			@grid.each do |row|
				if row[col_index] == char_var
					unless has_char
						has_char = true
					end
					count += 1
				elsif has_char and row[col_index] == " "
					count = char_var
					break
				end
			end
			@output << count
		end
		@output.join(" ")
	end
end

class Water
	def initialize(maxcount = 0)
		@water = "~"
		@count = 1
		@current_pos = [0,1] # x,y
		@maxcount = maxcount
	end

	def check_open_down(grid); grid[@current_pos[1]+1][@current_pos[0]] == " "; end

	def check_open_right(grid); grid[@current_pos[1]][@current_pos[0]+1] == " "; end

	def flow(grid)
		unless @count == @maxcount
			if check_open_down(grid)
				grid = flow_down(grid)
			elsif check_open_right(grid)
				grid = flow_right(grid)
			else
				@current_pos[1] -= 1
				@current_pos[0] = grid[ @current_pos[1] ].rindex( @water )
			end
			grid
		else
			"DONE"
		end
	end
	
	private
	def flow_core(val, grid)
		sleep(0.1)
		@count += 1
		@current_pos[val] += 1 
		grid[@current_pos[1]][@current_pos[0]] = @water
		grid
	end

	def flow_down(grid)
		flow_core(1,grid)
	end

	def flow_right(grid)
		flow_core(0,grid)
	end
end

def run(file)
	cave = Cave.new(file)
	water = Water.new(cave.stop_point)
	status = cave.grid
	until status == "DONE"
		->(a,b,c){x=a.method(b);a.send(c,b){send c,b,&x;false};print"\e[2J\e[H \e[D"}[irb_context,:echo?,:define_singleton_method]
		puts cave.grid.map{|i| i.join('')}.join("\n")+"\n\n"
		cave.grid = status.dup
		status = water.flow(cave.grid)
	end
	puts "\n\n#{cave.down_count_char}\n\n -- COMPLETED! -- \n\n"
end

run("simple_cave.txt")
sleep(6)
run("complex_cave.txt")