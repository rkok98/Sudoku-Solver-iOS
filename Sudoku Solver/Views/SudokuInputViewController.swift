import Foundation
import SwiftUI

public class SudokuInputViewController: ObservableObject {
	/**
	 Returns a random sudoku
	 */
	public func random(isNRCSudoku: Bool) -> [Int?] {
		let str = isNRCSudoku ? nrcSudokus.randomElement()! : sudokus.randomElement()!
		return Sudoku.parse(str).flatten()
	}

	/**
	 Returns an empty sudoku
	 */
	public func clear(width: Int) -> [Int?] {
		return Sudoku.emptySudoku(width).flatten()
	}

	/**
	 Converts an array of optional integers to a sudoku
	 */
	public func toSudoku(_ values: [Int?], width: Int) -> Sudoku {
		var sudoku = Sudoku.emptySudoku()

		for (index, value) in values.enumerated() {
			let row = index / width
			let col = index % width

			sudoku[row][col] = value
		}

		return sudoku
	}

	/**
	 Returns a sudoku to optional integer array
	 */
	public func fromSudoku(_ sudoku: Sudoku) -> [Int?] {
		return sudoku.flatten()
	}

	/**
	 Solves a sudoku
	 */
	public func solve(_ sudoku: Sudoku, solver: SudokuSolver) throws -> Sudoku {
		return try solver.solve(sudoku)
	}
}
