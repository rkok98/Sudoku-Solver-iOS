import Algorithms
import Foundation

public typealias Sudoku = [[Int?]]
public typealias SubGrid = [Int?]
public typealias Row = [Int?]
public typealias Col = [Int?]

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

	func getRow(_ row: Int) -> Row {
		return self[row]
	}

	func getCol(_ col: Int) -> Col {
		return self.map { $0[col] }
	}

	func getSubGrid(row: Int, col: Int) -> SubGrid {
		let sqrt = Int(Double(self.count).squareRoot())
		let block = (row / sqrt) * sqrt + (col / sqrt)

		return self.getSubGrids()[block]
	}

	var width: Int {
		return self.count
	}

	var height: Int {
		return self[0].count
	}

	var description: String {
		var string = ""

		for row in self {
			string += self.describeRow(row)
		}

		return string
	}

	func getSubGridsStartPosition() -> [Position] {
		let sqrt = Int(Double(self.count).squareRoot())
		var positions = stride(from: 0, to: self.count, by: sqrt).compactMap { $0 }

		positions.append(contentsOf: positions)

		return positions.uniquePermutations(ofCount: 2).map { Position($0[0], $0[1]) }
	}

	func getSubGrids() -> [SubGrid] {
		let sqrt = Int(Double(self.count).squareRoot())
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
