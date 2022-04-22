import Algorithms
import Foundation

public typealias Sudoku = [[Int?]]

public typealias SubGrid = [Int?]

public typealias Row = [Int?]
public typealias Col = [Int?]

public extension Sudoku {
	/**
	 Parses a string to a Sudoku

	 - Parameters:
	 - openPosition: The number of the open position
	 */
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
	func getGrid(blocks: [[Int]], row: Int, col: Int) -> SubGrid {
		return product(blocks, blocks).filter { rows, cols in
			rows.contains(row) && cols.contains(col)
		}.map { rows, cols in
			product(rows, cols).map { row, col in
				self[row][col]
			}
		}.first ?? [] // Return empty array if position is not in a sub grid
	}

	func getGrids(_ blocks: [[Int]]) -> [SubGrid] {
		return product(blocks, blocks).map { rows, cols in
			product(rows, cols).map { row, col in
				self[row][col]
			}
		}
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
		return self.map { row in
			describeRow(row)
		}.joined(separator: "\n")
	}

	/**
	 Returns all open positions in the sudoku sorted by position.
	 */
	func getOpenPositions() -> [Position] {
		return self.enumerated().flatMap { row, seq in
			seq.enumerated().compactMap { col, val in
				if val == nil {
					return Position(row, col)
				}

				return nil
			}
		}
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
		return row.map { digit in
			if let digit = digit {
				return String(describing: digit)
			}

			return " "
		}.joined(separator: " ")
			.trimmingCharacters(in: .whitespaces)
	}
}
