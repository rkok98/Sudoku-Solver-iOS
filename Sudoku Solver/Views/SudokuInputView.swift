import SwiftUI

struct SudokuCellView: View {
	private let nrcBlocks = [[Int](1...3), [Int](5...7)].joined()

	private let row: Int
	private let col: Int

	private var id: String

	@Binding var value: Int?
	@Binding var nrcSudoku: Bool

	@FocusState var focusedField: String?

	public init(row: Int, col: Int, value: Binding<Int?>, nrcSudoku: Binding<Bool>, focusedField: FocusState<String?>) {
		self.row = row
		self.col = col

		self._value = value
		self._nrcSudoku = nrcSudoku
		self._focusedField = focusedField

		self.id = "\(row)-\(col)"
	}

	private func changeFocus() {
		if col < 8 {
			focusedField = "\(row)-\(col + 1)"
		} else if row < 8 {
			focusedField = "\(row + 1)-0"
		}
	}

	private func isNRCGrid() -> Bool {
		return nrcBlocks.contains(row) && nrcBlocks.contains(col)
	}

	var body: some View {
		TextField("", value: $value, format: .number)
			.keyboardType(UIKeyboardType.default)
			.font(Font.system(size: 32, design: .default))
			.foregroundColor(Color.primary)
			.multilineTextAlignment(.center)
			.border(Color.primary.opacity(0.2))
			.focused($focusedField, equals: self.id)
			.submitLabel(.next)
			.onSubmit(changeFocus)
			.background(isNRCGrid() && nrcSudoku ? Color(uiColor: UIColor.secondarySystemBackground) : Color(uiColor: UIColor.systemBackground))
	}
}

struct SudokuView: View {
	@FocusState var focusedField: String?

	@Binding var values: [Int?]
	@Binding var nrcSudoku: Bool

	@State var columns: [GridItem]

	private let controller = SudokuInputViewController()
	private let spacing: CGFloat = 0

	init(_ values: Binding<[Int?]>, nrcSudoku: Binding<Bool>) {
		self._values = values
		self._nrcSudoku = nrcSudoku

		self._columns = State<[GridItem]>(initialValue: Array(repeating: GridItem(.flexible(), spacing: spacing, alignment: .center), count: 9))
	}

	var body: some View {
		LazyVGrid(columns: columns, spacing: spacing) {
			ForEach(0 ..< values.count, id: \.self) { i in
				let row = i / 9
				let col = i % 9

				SudokuCellView(row: row, col: col, value: $values[i], nrcSudoku: $nrcSudoku, focusedField: self._focusedField)
			}
		}.mask(RoundedRectangle(cornerRadius: 12.5))
			.background(RoundedRectangle(cornerRadius: 12.5)
				.background(RoundedRectangle(cornerRadius: 12.5)
					.fill(Color(uiColor: UIColor.tertiarySystemBackground))))
	}
}

struct SudokuInputView: View {
	@StateObject private var controller = SudokuInputViewController()

	@State var isSolving: Bool = false
	@State var nrcSudoku: Bool = true
	@State var values: [Int?]

	public init(nrOfSubGrids: Int = 9) {
		let nrOfValues = nrOfSubGrids * nrOfSubGrids
		self.values = Array(repeating: nil, count: nrOfValues)
	}

	private func solve() {
		hideKeyboard()

		isSolving = true

		let sudoku = controller.toSudoku(values)
		do {
			let solved = try controller.solve(sudoku)
			values = controller.fromSudoku(solved)
		} catch {
			// TODO:
		}

		isSolving = false
	}

	private func random() {
		hideKeyboard()
		values = controller.random()
	}

	private func clear() {
		hideKeyboard()
		values = controller.clear()
		nrcSudoku.toggle()
	}

	var body: some View {
		NavigationView {
			ScrollView {
				ZStack {
					VStack {
						HStack {
							Spacer()
							SudokuView($values, nrcSudoku: $nrcSudoku)
							Spacer()
						}
						HStack {
							Button("Solve 🤓", action: solve)
								.buttonStyle(.borderedProminent)
								.padding(16)
						}
					}
				}
			}.navigationTitle("Sudoku Solver")
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Random 🎲", action: random)
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Clear 💣", role: .destructive, action: clear)
					}
				}
		}.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct SudokuInputView_Previews: PreviewProvider {
	static var previews: some View {
		SudokuInputView()
			.previewDevice("iPad Air (5th generation)")
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
