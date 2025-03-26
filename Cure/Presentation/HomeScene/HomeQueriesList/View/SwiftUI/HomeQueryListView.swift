import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension HomeQueryListItemViewModel: Identifiable { }

@available(iOS 13.0, *)
struct HomeQueryListView: View {
    @ObservedObject var viewModelWrapper: HomeQueryListViewModelWrapper
    
    var body: some View {
        List(viewModelWrapper.items) { item in
            Button(action: {
                self.viewModelWrapper.viewModel?.didSelect(item: item)
            }) {
                Text(item.query)
            }
        }
        .onAppear {
            self.viewModelWrapper.viewModel?.viewWillAppear()
        }
    }
}

@available(iOS 13.0, *)
final class HomeQueryListViewModelWrapper: ObservableObject {
    var viewModel: HomeQueryListViewModel?
    @Published var items: [HomeQueryListItemViewModel] = []
    
    init(viewModel: HomeQueryListViewModel?) {
        self.viewModel = viewModel
        viewModel?.items.observe(on: self) { [weak self] values in self?.items = values }
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct HomeQueryListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeQueryListView(viewModelWrapper: previewViewModelWrapper)
    }
    
    static var previewViewModelWrapper: HomeQueryListViewModelWrapper = {
        var viewModel = HomeQueryListViewModelWrapper(viewModel: nil)
        viewModel.items = [HomeQueryListItemViewModel(query: "item 1"),
                           HomeQueryListItemViewModel(query: "item 2")
        ]
        return viewModel
    }()
}
#endif
