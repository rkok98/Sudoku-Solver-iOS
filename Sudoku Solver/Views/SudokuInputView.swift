import SwiftUI

struct SudokuCellView: View {
	let grid: Int
	let cell: Int

	@State var id: String?

	@Binding var value: Int?

	@FocusState var focusedField: String?

	let cellSize: CGFloat = 64

	public init(grid: Int, cell: Int, value: Binding<Int?>, focusedField: FocusState<String?>) {
		self.grid = grid
		self.cell = cell
		self._value = value
		self._focusedField = focusedField

		self._id = State<String?>(initialValue: "\(grid)-\(cell)")
	}

	var body: some View {
		TextField("", value: $value, format: .number)
			.keyboardType(UIKeyboardType.numberPad)
			.font(Font.system(size: 32, design: .default))
			.foregroundColor(Color.primary)
			.multilineTextAlignment(.center)
			.frame(width: cellSize, height: cellSize, alignment: .center)
			.border(Color.primary.opacity(0.2))
			.focused($focusedField, equals: self.id)
			.submitLabel(.next)
			.onSubmit {
				if cell < 8 {
					self.focusedField = "\(self.grid)-\(self.cell + 1)"
				} else if grid < 8 {
					self.focusedField = "\(self.grid + 1)-0"
				}
			}
	}
}

struct SudokuSubGrid: View {
	let id: Int

	@Binding var subGrid: SubGrid
	@FocusState var focusedField: String?

	private let spacing: CGFloat = 0

	var body: some View {
		VStack(spacing: spacing) {
			HStack(spacing: spacing) {
				SudokuCellView(grid: id, cell: 0, value: $subGrid[0], focusedField: _focusedField)
				SudokuCellView(grid: id, cell: 1, value: $subGrid[1], focusedField: _focusedField)
				SudokuCellView(grid: id, cell: 2, value: $subGrid[2], focusedField: _focusedField)
			}
			HStack(spacing: spacing) {
				SudokuCellView(grid: id, cell: 3, value: $subGrid[3], focusedField: _focusedField)
				SudokuCellView(grid: id, cell: 4, value: $subGrid[4], focusedField: _focusedField)
				SudokuCellView(grid: id, cell: 5, value: $subGrid[5], focusedField: _focusedField)
			}
			HStack(spacing: spacing) {
				SudokuCellView(grid: id, cell: 6, value: $subGrid[6], focusedField: _focusedField)
				SudokuCellView(grid: id, cell: 7, value: $subGrid[7], focusedField: _focusedField)
				SudokuCellView(grid: id, cell: 8, value: $subGrid[8], focusedField: _focusedField)
			}
		}.background(Rectangle()
			.strokeBorder(Color.primary, lineWidth: 2))
	}
}

struct SudokuView: View {
	private let controller = SudokuInputViewController()
	private let spacing: CGFloat = 0

	@FocusState var focusedField: String?

	@Binding var subGrids: [SubGrid]
	@State var isSolving: Bool = false

	var body: some View {
		ZStack {
			VStack(spacing: spacing) {
				ZStack {
					VStack(spacing: spacing) {
						HStack(spacing: spacing) {
							SudokuSubGrid(id: 0, subGrid: $subGrids[0], focusedField: _focusedField)
							SudokuSubGrid(id: 1, subGrid: $subGrids[1], focusedField: _focusedField)
							SudokuSubGrid(id: 2, subGrid: $subGrids[2], focusedField: _focusedField)
						}
						HStack(spacing: spacing) {
							SudokuSubGrid(id: 3, subGrid: $subGrids[3], focusedField: _focusedField)
							SudokuSubGrid(id: 4, subGrid: $subGrids[4], focusedField: _focusedField)
							SudokuSubGrid(id: 5, subGrid: $subGrids[5], focusedField: _focusedField)
						}
						HStack(spacing: spacing) {
							SudokuSubGrid(id: 6, subGrid: $subGrids[6], focusedField: _focusedField)
							SudokuSubGrid(id: 7, subGrid: $subGrids[7], focusedField: _focusedField)
							SudokuSubGrid(id: 8, subGrid: $subGrids[8], focusedField: _focusedField)
						}
					}
				}.mask(RoundedRectangle(cornerRadius: 12.5))
					.background(RoundedRectangle(cornerRadius: 12.5)
						.strokeBorder(Color.primary, lineWidth: 4)
						.background(RoundedRectangle(cornerRadius: 12.5)
							.fill(Color(uiColor: UIColor.tertiarySystemBackground))))
			}
		}
	}
}

struct SudokuInputView: View {
	@StateObject private var controller = SudokuInputViewController()

	@State var isSolving: Bool = false
	@State var nrOfSubGrids: Int
	@State var subGrids: [SubGrid]

	public init(nrOfSubGrids: Int = 9) {
		self.nrOfSubGrids = 9
		self.subGrids = Array(repeating: Array(repeating: nil, count: nrOfSubGrids), count: nrOfSubGrids)
	}

	var body: some View {
		ZStack {
			VStack {
				HStack {
					Spacer()
					Button("Random Sudoku 🎲", action: {
						hideKeyboard()
						subGrids = controller.random()
					}).buttonStyle(.bordered)
						.font(Font.title)
					Spacer()
					Button("Clear Sudoku 💣", role: .destructive) {
						hideKeyboard()
						subGrids = controller.clear(nrOfSubGrids: nrOfSubGrids)
					}.buttonStyle(.borderedProminent)
						.font(Font.title)
					Spacer()
				}.padding(.bottom, 16)
				SudokuView(subGrids: $subGrids)
				HStack {
					Button("Solve 🤓", action: {
						hideKeyboard()

						isSolving = true

						let sudoku = controller.parseSudoku(subGrids)
						let solved = controller.solve(sudoku)

						subGrids = controller.show(solved)

						isSolving = false
					}).buttonStyle(.borderedProminent)
						.font(Font.largeTitle)
						.padding(16)
				}
			}
		}
	}
}

struct SudokuInputView_Previews: PreviewProvider {
	static var previews: some View {
		SudokuInputView()
			.previewInterfaceOrientation(.portrait)
	}
}

#if canImport(UIKit)
extension View {
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
#endif
