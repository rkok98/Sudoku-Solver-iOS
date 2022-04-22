import XCTest

class NRCSudokuSolverTests: XCTestCase {
	let solver = NRCSudokuSolver()

	func testSolve() {
		let expected = """
		5 7 2 6 9 8 3 4 1
		8 1 6 7 3 4 2 9 5
		9 4 3 2 1 5 8 7 6
		4 8 5 9 2 6 1 3 7
		6 3 9 1 8 7 5 2 4
		7 2 1 5 4 3 9 6 8
		1 9 4 8 6 2 7 5 3
		2 6 7 3 5 1 4 8 9
		3 5 8 4 7 9 6 1 2
		"""

		let sudokuStr = """
		0 0 2 6 0 0 0 0 0
		0 0 0 7 0 0 0 0 0
		0 0 0 0 1 5 0 0 0
		0 0 5 0 2 0 1 0 7
		6 3 0 0 8 7 0 2 0
		0 0 0 0 4 3 9 0 0
		0 0 0 8 0 2 0 0 0
		0 6 0 0 0 0 4 0 0
		0 0 0 0 0 0 0 0 0
		"""

		let sudoku = Sudoku.parse(sudokuStr)

		XCTAssertEqual(try solver.solve(sudoku).description, expected)
	}
	
}
