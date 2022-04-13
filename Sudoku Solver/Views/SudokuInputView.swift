import SwiftUI

struct SudokuCellView: View {
	@Binding var value: Int?
	@FocusState var focusedField: UUID?
	@State var someTextFieldUUID = UUID()

	let cellSize: CGFloat = 64

	var body: some View {
		TextField("", value: $value, format: .number)
			.font(Font.system(size: 32, design: .default))
			.foregroundColor(Color.black)
			.multilineTextAlignment(.center)
			.frame(width: cellSize, height: cellSize, alignment: .center)
			.border(Color.black.opacity(0.2))
			.focused($focusedField, equals: someTextFieldUUID)
	}
}

struct SudokuSubGrid: View {
	@Binding var values: [Int?]
	@FocusState var focusedField: UUID?

	private let spacing: CGFloat = 0

	var body: some View {
		VStack(spacing: self.spacing) {
			HStack(spacing: self.spacing) {
				SudokuCellView(value: $values[0], focusedField: _focusedField)
				SudokuCellView(value: $values[1], focusedField: _focusedField)
				SudokuCellView(value: $values[2], focusedField: _focusedField)
			}
			HStack(spacing: self.spacing) {
				SudokuCellView(value: $values[3], focusedField: _focusedField)
				SudokuCellView(value: $values[4], focusedField: _focusedField)
				SudokuCellView(value: $values[5], focusedField: _focusedField)
			}
			HStack(spacing: self.spacing) {
				SudokuCellView(value: $values[6], focusedField: _focusedField)
				SudokuCellView(value: $values[7], focusedField: _focusedField)
				SudokuCellView(value: $values[8], focusedField: _focusedField)
			}
		}.background(Rectangle().strokeBorder(Color.black, lineWidth: 2))
	}
}

struct SudokuView: View {
	@State var values: [SubGrid] = Array(repeating: Array(repeating: nil, count: 9), count: 9)
	@FocusState var focusedField: UUID?

	var controller = SudokuInputViewController()

	let spacing: CGFloat = 0

	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: Rainbow.hueColors),
						   startPoint: .leading,
						   endPoint: .trailing).ignoresSafeArea(.all)
			VStack(spacing: spacing) {
				HStack {
					Spacer()
					Button("Fill 💅", action: {
						self.values = controller.temp()
					}).buttonStyle(.borderedProminent)
						.font(Font.title)
					Spacer()
					Button("Clear 🌪", role: .destructive) {
						self.values = Array(repeating: Array(repeating: nil, count: 9), count: 9)
					}.buttonStyle(.borderedProminent)
						.font(Font.title)
					Spacer()
				}.padding(16)
				VStack(spacing: spacing) {
					HStack(spacing: spacing) {
						SudokuSubGrid(values: $values[0], focusedField: _focusedField)
						SudokuSubGrid(values: $values[1], focusedField: _focusedField)
						SudokuSubGrid(values: $values[2], focusedField: _focusedField)
					}
					HStack(spacing: spacing) {
						SudokuSubGrid(values: $values[3], focusedField: _focusedField)
						SudokuSubGrid(values: $values[4], focusedField: _focusedField)
						SudokuSubGrid(values: $values[5], focusedField: _focusedField)
					}
					HStack(spacing: spacing) {
						SudokuSubGrid(values: $values[6], focusedField: _focusedField)
						SudokuSubGrid(values: $values[7], focusedField: _focusedField)
						SudokuSubGrid(values: $values[8], focusedField: _focusedField)
					}
				}.mask(RoundedRectangle(cornerRadius: 12.5))
					.background(RoundedRectangle(cornerRadius: 12.5)
						.strokeBorder(Color.black, lineWidth: 4)
						.background(RoundedRectangle(cornerRadius: 12.5).fill(Color.white)))
				HStack {
					Button("Solve 🤓", action: {
						let sudoku = controller.parseSudoku(self.values)
						let solved = controller.solve(sudoku)
						self.values = controller.show(solved)
					}).buttonStyle(.borderedProminent)
						.tint(Color.indigo)
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
