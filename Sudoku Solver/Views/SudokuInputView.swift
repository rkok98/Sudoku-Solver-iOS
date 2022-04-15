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

	@Binding var values: [Int?]
	@FocusState var focusedField: String?

	private let spacing: CGFloat = 0

	var body: some View {
		VStack(spacing: self.spacing) {
			HStack(spacing: self.spacing) {
				SudokuCellView(grid: self.id, cell: 0, value: $values[0], focusedField: _focusedField)
				SudokuCellView(grid: self.id, cell: 1, value: $values[1], focusedField: _focusedField)
				SudokuCellView(grid: self.id, cell: 2, value: $values[2], focusedField: _focusedField)
			}
			HStack(spacing: self.spacing) {
				SudokuCellView(grid: self.id, cell: 3, value: $values[3], focusedField: _focusedField)
				SudokuCellView(grid: self.id, cell: 4, value: $values[4], focusedField: _focusedField)
				SudokuCellView(grid: self.id, cell: 5, value: $values[5], focusedField: _focusedField)
			}
			HStack(spacing: self.spacing) {
				SudokuCellView(grid: self.id, cell: 6, value: $values[6], focusedField: _focusedField)
				SudokuCellView(grid: self.id, cell: 7, value: $values[7], focusedField: _focusedField)
				SudokuCellView(grid: self.id, cell: 8, value: $values[8], focusedField: _focusedField)
			}
		}.background(Rectangle().strokeBorder(Color.primary, lineWidth: 2))
	}
}

struct SudokuView: View {
	@FocusState var focusedField: String?

	@State var values: [SubGrid] = Array(repeating: Array(repeating: nil, count: 9), count: 9)
	@State var isSolving: Bool = false

	var controller = SudokuInputViewController()

	let spacing: CGFloat = 0

	var body: some View {
		ZStack {
			VStack(spacing: spacing) {
				HStack {
					Spacer()
					Button("Random Sudoku 🎲", action: {
						hideKeyboard()
						self.values = controller.temp()
					}).buttonStyle(.bordered)
						.font(Font.title)
					Spacer()
					Button("Clear Sudoku 💣", role: .destructive) {
						hideKeyboard()
						self.values = Array(repeating: Array(repeating: nil, count: 9), count: 9)
					}.buttonStyle(.borderedProminent)
						.font(Font.title)
					Spacer()
				}.padding(16)
				ZStack {
					if self.isSolving {
						ProgressView("Solving Sudoku")
							.progressViewStyle(CircularProgressViewStyle())
					}
					VStack(spacing: spacing) {
						HStack(spacing: spacing) {
							SudokuSubGrid(id: 0, values: $values[0], focusedField: _focusedField)
							SudokuSubGrid(id: 1, values: $values[1], focusedField: _focusedField)
							SudokuSubGrid(id: 2, values: $values[2], focusedField: _focusedField)
						}
						HStack(spacing: spacing) {
							SudokuSubGrid(id: 3, values: $values[3], focusedField: _focusedField)
							SudokuSubGrid(id: 4, values: $values[4], focusedField: _focusedField)
							SudokuSubGrid(id: 5, values: $values[5], focusedField: _focusedField)
						}
						HStack(spacing: spacing) {
							SudokuSubGrid(id: 6, values: $values[6], focusedField: _focusedField)
							SudokuSubGrid(id: 7, values: $values[7], focusedField: _focusedField)
							SudokuSubGrid(id: 8, values: $values[8], focusedField: _focusedField)
						}
					}
				}.mask(RoundedRectangle(cornerRadius: 12.5))
					.background(RoundedRectangle(cornerRadius: 12.5)
						.strokeBorder(Color.primary, lineWidth: 4)
						.background(RoundedRectangle(cornerRadius: 12.5)
							.fill(Color(uiColor: UIColor.tertiarySystemBackground))))
				HStack {
					Button("Solve 🤓", action: {
						hideKeyboard()
						self.isSolving = true
						let sudoku = controller.parseSudoku(self.values)
						let solved = controller.solve(sudoku)
						self.values = controller.show(solved)
						self.isSolving = false
					}).buttonStyle(.borderedProminent)
						.font(Font.largeTitle)
						.padding(16)
				}
			}
		}
	}
}

struct SudokuInputView: View {
	var body: some View {
		SudokuView()
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
