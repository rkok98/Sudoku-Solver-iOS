import Algorithms
import Foundation

public typealias Sudoku = [[Int?]]

public extension Sudoku {
	static func parse(_ string: String, openPosition: Int = 0) -> Sudoku {
		var sudoku: Sudoku = []

		string.enumerateLines { line, _ in
			sudoku.append(parseRow(line, openPosition: openPosition))
		}

		return sudoku
	}

	/**
	 Returns a new copy of the sudoku with the extended value.
	 */
	func extend(row: Int, column: Int, value: Int) -> Sudoku {
		var sudoku = self
		sudoku[row][column] = value

		return sudoku
	}

	/**
	- Parameters:
		 - row: The *index* of a row in the sudoku

	- Returns:
		an array of the values inside the specified row
	 */
	func getRow(_ row: Int) -> Row {
		return self[row]
	}

	/**
	- Parameters:
		 - col: The *index* of a column in the sudoku

	- Returns:
		an array of the values inside the specified column
	 */
	func getCol(_ col: Int) -> Col {
		return self.map { $0[col] }
	}

	/**
	 - Parameters:
		 - row: The index of a row in the sudoku.
		 - col: The index of a column in the sudoku.

	 - Returns:
		an array of the values inside the specified column
	 */
	func getSubGrid(row: Int, col: Int) -> SubGrid {
		let sqrt = sqrt(self.count)
		let block = (row / sqrt) * sqrt + (col / sqrt)

		return self.getSubGrids()[block]
	}

	/**
	- Returns:
		The width of the sudoku
	*/
	var width: Int {
		return self.count
	}

	/**
	 - Returns:
	 The height of the sudoku
	 */
	var height: Int {
		return self[0].count
	}

	/**
	 The sudoku as in string format
	```
		3 9 6 8 5 1 7 4 2
		1 7 8 2 9 4 3 5 6
		5 2 4 6 7 3 8 9 1
		9 1 5 4 8 7 2 6 3
		4 8 3 9 2 6 5 1 7
		2 6 7 3 1 5 9 8 4
		6 5 2 1 3 8 4 7 9
		7 4 9 5 6 2 1 3 8
		8 3 1 7 4 9 6 2 5
	```
	 */
	var description: String {
		var string = ""

		for row in self {
			string += self.describeRow(row)
		}

		return string
	}


	func getSubGridsStartPosition() -> [Position] {
		let sqrt = sqrt(self.count)
		var positions = stride(from: 0, to: self.count, by: sqrt).compactMap { $0 }

		positions.append(contentsOf: positions)

		return positions.uniquePermutations(ofCount: 2).map { Position($0[0], $0[1]) }
	}

	func getSubGrids() -> [SubGrid] {
		let sqrt = sqrt(self.count)
		var grids = [[Int?]](repeating: [], count: self.count)

		for (rowIndex, row) in self.enumerated() {
			for (colIndex, col) in row.enumerated() {
				let block: Int = (rowIndex / sqrt) * sqrt + (colIndex / sqrt)
				grids[block].append(col)
			}
		}

		return grids
	}

	func getOpenPositions() -> [Position] {
		var positions: [Position] = []

		for (row, sequence) in self.enumerated() {
			for (col, value) in sequence.enumerated() {
				if value == nil {
					positions.append(Position(row, col))
				}
			}
		}

		return positions
	}

	private static func parseRow(_ row: String, openPosition: Int) -> [Int?] {
		// TODO: Error Handling
		// let pattern = "[0-9]+[0-9]*\\s*"
		// let regex = try! NSRegularExpression(pattern: pattern)
		// regex.firstMatch(in: <#T##String#>, range: <#T##NSRange#>)

		return row.split(separator: " ").compactMap {
			Int($0) == openPosition ? nil : Int($0)
		}
	}

	private func describeRow(_ row: [Int?]) -> String {
		var string = ""

		for digit in row {
			if let digit = digit {
				string += "\(String(describing: digit)) "
			} else {
				string += "  "
			}
		}

		return string + "\n"
	}
}
