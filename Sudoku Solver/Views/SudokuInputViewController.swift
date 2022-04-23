import Foundation
import SwiftUI

public class SudokuInputViewController: ObservableObject {
	private let blocks = [[Int](0...2), [Int](3...5), [Int](6...8)]
	private let width = 9

	public func random() -> [Int?] {
		let str = sudokus.randomElement()!
		return Sudoku.parse(str).reduce([], +)
	}

	public func clear() -> [Int?] {
		return Sudoku.emptySudoku(width).flatten()
	}

	public func toSudoku(_ values: [Int?]) -> Sudoku {
		var sudoku = Sudoku.emptySudoku()

		for (index, value) in values.enumerated() {
			let row = index / width
			let col = index % width

			sudoku[row][col] = value
		}

		return sudoku
	}

	public func fromSudoku(_ sudoku: Sudoku) -> [Int?] {
		return sudoku.flatten()
	}

	public func solve(_ sudoku: Sudoku) throws -> Sudoku {
		let solver = SudokuSolver()
		return try solver.solve(sudoku)
	}

	public func printValues(_ values: [SubGrid]) {
		print(values)
	}
}
