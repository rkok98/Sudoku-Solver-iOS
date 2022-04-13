@testable import Sudoku_Solver
import XCTest

class SudokuSolverTests: XCTestCase {
	func testConstraints() {
		let string = """
		0 9 6 8 5 1 0 4 2
		1 0 8 2 9 4 3 5 6
		5 2 0 6 7 0 8 0 1
		9 1 5 0 8 7 2 6 3
		4 8 3 9 0 6 5 0 7
		2 6 7 3 1 0 9 8 4
		6 5 0 1 3 8 0 7 9
		7 4 9 5 6 2 1 0 8
		0 3 1 7 4 9 0 2 5
		"""

		let sudoku = Sudoku.parse(string)

		print(SudokuSolver.constraints(sudoku))
	}

	func testConsistent() {
		let string = """
		3 9 6 8 5 1 7 4 2
		1 7 8 2 9 4 3 5 6
		5 2 4 6 7 3 8 9 1
		9 1 5 4 8 7 2 6 3
		4 8 3 9 2 6 5 1 7
		2 6 7 3 1 5 9 8 4
		6 5 2 1 3 8 4 7 9
		7 4 9 5 6 2 1 3 8
		8 3 1 7 4 9 6 2 5
		"""

		let sudoku = Sudoku.parse(string)

		XCTAssertTrue(SudokuSolver.consistent(sudoku))
	}

	func testSolve() {
		let string = """
		0 9 6 8 5 1 7 4 2
		1 0 8 2 9 4 3 5 6
		5 2 0 6 7 3 8 9 1
		9 1 5 0 8 7 2 6 3
		4 8 3 9 0 6 5 1 7
		2 6 7 3 1 0 9 8 4
		6 5 0 1 3 8 0 7 9
		7 4 9 5 6 2 1 0 8
		0 3 1 7 4 9 6 2 5
		"""

		let sudoku = Sudoku.parse(string)

		print(SudokuSolver.solve(sudoku)[0].description)
	}
}
