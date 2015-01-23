module dgol.app;

import std.stdio;
import std.conv;

import dgol.gol;
import dsfml.graphics;

void main(string[] args)
{
	bool[][] table;
	bool[][][] history;
	int square_size;
	int number_of_cells;

	if(args.length < 2){
		number_of_cells = 40;	
	}
	else{
		number_of_cells = to!int(args[1]);
	}

	int height = 1000;
	int width = 1000;

	table = init_array(number_of_cells);

	square_size = height / number_of_cells;

	auto window = new RenderWindow(VideoMode(height, width), "D Game of Life", (Window.Style.Titlebar | Window.Style.Close), ContextSettings.Default);

	draw_table_window(window, table, square_size);
	history ~= table;

	while (window.isOpen())
    {
        Event event;

        while(window.pollEvent(event))
        {
            if(event.type == event.EventType.Closed)
            {
                window.close();
            }
            else if(event.type == event.EventType.MouseButtonPressed){
            	change_state(table, event.mouseButton.x, event.mouseButton.y, square_size);
            	draw_table_window(window, table, square_size);
            }
            else if(event.type == event.EventType.KeyPressed){
            	if(event.key.code == Keyboard.Key.BackSpace){
            		history = [];
            		table = init_array(table.length);
            		draw_table_window(window, table, square_size);
            	}
            	else if(event.key.code == Keyboard.Key.R){
            		history = [];
            		table = random_array(table.length);
            		draw_table_window(window, table, square_size);
            	}
            	else if(event.key.code == Keyboard.Key.E){
            		history ~= table;
            		table = evaluate(table);
            		draw_table_window(window, table, square_size);
            	}
            	else if(event.key.code == Keyboard.Key.D){
            		if(history.length > 1){
            			history = history[0..$-1];
            			table = history[$-1];
            			draw_table_window(window, table, square_size);
            		}
            	}
            }
        }

        if(Keyboard.isKeyPressed(Keyboard.Key.Space)){
        	history ~= table;
        	table = evaluate(table);
        	draw_table_window(window, table, square_size);
        }

        if(Keyboard.isKeyPressed(Keyboard.Key.Return)){
        	if(history.length > 1){
            	history = history[0..$-1];
            	table = history[$-1];
            	draw_table_window(window, table, square_size);
            }
        }

        window.display();
    }

}

/**
 * print a table on stdout.
 * @param  {bool[][]} bool[][] table         table to print
 */
void print_table(bool[][] table)
{
	writeln("table :");
	foreach(line; table) {
		foreach(cell; line) {
			if(cell){
				write("x ");
			}
			else{
				write("o ");
			}
		}

		writeln("");
	}
}

/**
 * Draw the table on the window
 */
void draw_table_window(RenderWindow window, bool[][] table, int square_size)
{
	window.clear(Color.Black);
	for(int i = 0; i < table.length; i++)
	{
		for(int j = 0; j < table[i].length; j++)
		{
			if(table[i][j]){
				auto square = new RectangleShape(Vector2f(square_size, square_size));
				square.fillColor = Color.White;
				square.position = Vector2f(i * square_size - 2, j * square_size);

				square.outlineThickness = 2;
				square.outlineColor(Color.White);
				window.draw(square);
			}
			else{
				auto square = new RectangleShape(Vector2f(square_size, square_size));
				square.fillColor = Color.Black;
				square.position = Vector2f(i * square_size - 2, j * square_size);

				square.outlineThickness = 2;
				square.outlineColor(Color.White);
				window.draw(square);
			}
		}
	}
}

void change_state(bool[][] table, int x, int y, in int square_size)
{
	int i = x / square_size;
	int j = y /square_size;

	if(table[i][j]){
		table[i][j] = false;
	}
	else{
		table[i][j] = true;
	}
}