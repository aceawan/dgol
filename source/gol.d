module dgol.gol;

import std.stdio;

/**
 * returns a 2Darray with size
 * @param  {size_t} size_t size          size of the array.
 * @return {bool[][]}        initialized array.
 */
bool[][] init_array(size_t size)
in
{
	assert(size > 0);
}
body
{
	bool[][] multi_array;

	multi_array.length = size;

	foreach(ref array; multi_array)
	{
		array.length = size;
	}

	return multi_array;
}

/**
 * evaluate an array of bool with the rules of gol
 * @param  {bool[][]}		   array to evaluate
 * @return {bool[][]}          array evaluated
 */
bool[][] evaluate(bool[][] array)
{
	bool[][] evaluated_array;
	evaluated_array = init_array(array.length);

	for(int i = 0; i < array.length; i++)
	{
		for(int j = 0; j < array[i].length; j++)
		{
			if(array[i][j])
			{
				if(count_alive(array, array.length, i, j) != 2 && count_alive(array, array.length, i, j) != 3)
				{
					evaluated_array[i][j] = false;
				}
				else{
					evaluated_array[i][j] = array[i][j];
				}
			}
			else
			{
				if(count_alive(array, array.length, i, j) == 3)
				{
					evaluated_array[i][j] = true;
				}
				else{
					evaluated_array[i][j] = array[i][j];
				}
			}
		}
	}

	return evaluated_array;
}

/**
 * Count the alive cells around a cell
 * 
 */
int count_alive(bool[][] array, size_t size, int x, int y)
{
	int living_cells = 0;

	if(in_table(x+1, y+1, size))
	{
		if(array[x+1][y+1]){
			living_cells++;
		}
	}
	if(in_table(x-1, y-1, size))
	{
		if(array[x-1][y-1]){
			living_cells++;
		}
	}
	if(in_table(x+1, y-1, size))
	{
		if(array[x+1][y-1]){
			living_cells++;
		}
	}
	if(in_table(x-1, y+1, size))
	{
		if(array[x-1][y+1]){
			living_cells++;
		}
	}
	if(in_table(x, y+1, size))
	{
		if(array[x][y+1]){
			living_cells++;
		}
	}
	if(in_table(x, y-1, size))
	{
		if(array[x][y-1]){
			living_cells++;
		}
	}
	if(in_table(x+1, y, size))
	{
		if(array[x+1][y]){
			living_cells++;
		}
	}
	if(in_table(x-1, y, size))
	{
		if(array[x-1][y]){
			living_cells++;
		}		
	}

	return living_cells;
}

unittest {
	bool[][] test_array = [[true,true,true],
						   [false, true, false],
						   [false, false, false]];
	assert(count_alive(test_array, test_array.length, 1, 1) == 3);

	test_array = [[true,true,true],
				  [true, true, true],
				  [true, false, true]];

	assert(count_alive(test_array, test_array.length, 1, 1) == 7);

	test_array = init_array(4);

	test_array[1][1] = true;
	test_array[1][2] = true;
	test_array[2][1] = true;
	test_array[2][2] = true;

	writeln(test_array);

	assert(count_alive(test_array, test_array.length, 1, 1) == 3);
}

/**
 * check if a cell is int the table
 */
bool in_table(int x, int y, size_t size)
{
	if(x < 0 || y < 0)
	{
		return false;
	}
	else if(x >= size || y >= size)
	{
		return false;
	}
	else
	{
		return true;
	}
}

unittest {
	assert(in_table(5,5,8));
	assert(!in_table(-1,0,8));
	assert(!in_table(9,9,8));
}
