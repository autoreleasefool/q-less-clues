import ComposableArchitecture

public enum DeletePlayAlertAction: Equatable {
	case didTapDeleteButton
	case didTapCancelButton
}

let deleteAlert = AlertState<DeletePlayAlertAction>(
	title: .init("Do you want to delete this play?"),
	primaryButton: .destructive(
		.init("Delete"),
		action: .send(.didTapDeleteButton)
	),
	secondaryButton: .cancel(
		.init("Nevermind"),
		action: .send(.didTapCancelButton)
	)
)
