import XCTest

class SudokuTests: XCTestCase {
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

	func testParse() {
		let sudoku = """
		3 9 6 8 5 1 7 4 2
		1 7 8 2 9 4 3 5 6
		5 2 4 6 7 3 8 9 1
		9 1 5 4 8 7 2 6 3
		4 8 3 9 2 6 5 1 7
		2 6 7 3 1 5 9 8 4
		6 5 2 1 3 8 4 7 9
		7 4 9 5 6 2 1 3 8
		8 3 1 7 4 0 6 2 5
		"""

		let expected: Sudoku = [
			[3, 9, 6, 8, 5, 1, 7, 4, 2],
			[1, 7, 8, 2, 9, 4, 3, 5, 6],
			[5, 2, 4, 6, 7, 3, 8, 9, 1],
			[9, 1, 5, 4, 8, 7, 2, 6, 3],
			[4, 8, 3, 9, 2, 6, 5, 1, 7],
			[2, 6, 7, 3, 1, 5, 9, 8, 4],
			[6, 5, 2, 1, 3, 8, 4, 7, 9],
			[7, 4, 9, 5, 6, 2, 1, 3, 8],
			[8, 3, 1, 7, 4, nil, 6, 2, 5]
		]

		XCTAssertEqual(Sudoku.parse(sudoku), expected, "Parsed sudoku does not match the expected sudoku")
	}

	func testExtend() {
		let expected = """
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

		let sudokuStr = """
		0 9 6 8 5 1 7 4 2
		1 7 8 2 9 4 3 5 6
		5 2 4 6 7 3 8 9 1
		9 1 5 4 8 7 2 6 3
		4 8 3 9 2 6 5 1 7
		2 6 7 3 1 5 9 8 4
		6 5 2 1 3 8 4 7 9
		7 4 9 5 6 2 1 3 8
		8 3 1 7 4 9 6 2 5
		"""

		let sudoku = Sudoku.parse(sudokuStr)

		XCTAssertEqual(sudoku.extend(row: 0, column: 0, value: 3), Sudoku.parse(expected), "Sudoku did not extend")
	}

	func testExtendMakesCopy() {
		let sudokuStr = """
		0 9 6 8 5 1 7 4 2
		1 7 8 2 9 4 3 5 6
		5 2 4 6 7 3 8 9 1
		9 1 5 4 8 7 2 6 3
		4 8 3 9 2 6 5 1 7
		2 6 7 3 1 5 9 8 4
		6 5 2 1 3 8 4 7 9
		7 4 9 5 6 2 1 3 8
		8 3 1 7 4 9 6 2 5
		"""

		let sudoku = Sudoku.parse(sudokuStr)
		let sudoku2 = sudoku.extend(row: 0, column: 0, value: 3)

		XCTAssertNotEqual(sudoku, sudoku2, "Extend made no copies, both sudokus are equal")
	}

	func testGetRow() {
		let sudoku = Sudoku.parse(self.string)
		XCTAssertEqual(sudoku.getRow(0), [3, 9, 6, 8, 5, 1, 7, 4, 2])
	}

	func testGetCol() {
		let sudoku = Sudoku.parse(self.string)
		XCTAssertEqual(sudoku.getCol(0), [3, 1, 5, 9, 4, 2, 6, 7, 8])
	}

	func testGetGrid() {
		let sudoku = Sudoku.parse(self.string)
		let blocks = [[Int](0...2), [Int](3...5), [Int](6...8)]

		XCTAssertEqual(sudoku.getGrid(blocks: blocks, row: 0, col: 0), [3, 9, 6, 1, 7, 8, 5, 2, 4])
	}

	func testGetGrids() {
		let sudoku = Sudoku.parse(self.string)
		let blocks = [[Int](0...2), [Int](3...5), [Int](6...8)]


		XCTAssertEqual(sudoku.getGrids(blocks), [
			[
				3, 9, 6,
				1, 7, 8,
				5, 2, 4
			],
			[
				8, 5, 1,
				2, 9, 4,
				6, 7, 3
			],
			[
				7, 4, 2,
				3, 5, 6,
				8, 9, 1
			],
			[
				9, 1, 5,
				4, 8, 3,
				2, 6, 7
			],
			[
				4, 8, 7,
				9, 2, 6,
				3, 1, 5
			],
			[
				2, 6, 3,
				5, 1, 7,
				9, 8, 4
			],
			[
				6, 5, 2,
				7, 4, 9,
				8, 3, 1
			],
			[
				1, 3, 8,
				5, 6, 2,
				7, 4, 9
			],
			[
				4, 7, 9,
				1, 3, 8,
				6, 2, 5
			]
		])
	}

	func testGetOpenPositions() {
		let expected = [Position(6, 6), Position(8, 0)]

		let sudoku: Sudoku = [
			[3, 9, 6, 8, 5, 1, 7, 4, 2],
			[1, 7, 8, 2, 9, 4, 3, 5, 6],
			[5, 2, 4, 6, 7, 3, 8, 9, 1],
			[9, 1, 5, 4, 8, 7, 2, 6, 3],
			[4, 8, 3, 9, 2, 6, 5, 1, 7],
			[2, 6, 7, 3, 1, 5, 9, 8, 4],
			[6, 5, 2, 1, 3, 8, nil, 7, 9],
			[7, 4, 9, 5, 6, 2, 1, 3, 8],
			[nil, 3, 1, 7, 4, 9, 6, 2, 5]
		]

		XCTAssertEqual(sudoku.getOpenPositions(), expected)
	}

	func testHeight() {
		let sudoku: Sudoku = [
			[3, 9, 6, 8, 5, 1, 7, 4, 2],
			[1, 7, 8, 2, 9, 4, 3, 5, 6],
			[5, 2, 4, 6, 7, 3, 8, 9, 1],
			[9, 1, 5, 4, 8, 7, 2, 6, 3],
			[4, 8, 3, 9, 2, 6, 5, 1, 7],
			[2, 6, 7, 3, 1, 5, 9, 8, 4],
			[6, 5, 2, 1, 3, 8, 4, 7, 9],
			[7, 4, 9, 5, 6, 2, 1, 3, 8],
			[8, 3, 1, 7, 4, 9, 6, 2, 5]
		]

		let expected = 9

		XCTAssertEqual(sudoku.height, expected, "The expected heigth of \(expected) is not returned")
	}

	func testWidth() {
		let sudoku: Sudoku = [
			[3, 9, 6, 8, 5, 1, 7, 4, 2],
			[1, 7, 8, 2, 9, 4, 3, 5, 6],
			[5, 2, 4, 6, 7, 3, 8, 9, 1],
			[9, 1, 5, 4, 8, 7, 2, 6, 3],
			[4, 8, 3, 9, 2, 6, 5, 1, 7],
			[2, 6, 7, 3, 1, 5, 9, 8, 4],
			[6, 5, 2, 1, 3, 8, nil, 7, 9],
			[7, 4, 9, 5, 6, 2, 1, 3, 8],
			[nil, 3, 1, 7, 4, 9, 6, 2, 5]
		]

		let expected = 9

		XCTAssertEqual(sudoku.width, expected, "The expected width of \(expected) is not returned")
	}

	func testDescription() {
		let expected = string
		let sudoku = Sudoku.parse(string)

		XCTAssertEqual(sudoku.description, expected)
	}
}
