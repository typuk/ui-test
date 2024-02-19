import XCTest
@testable import Test

final class JokeListViewModelTests: XCTestCase {

    private var viewModel: JokeListViewModel!
    private var jokeRepository: JokeRepositoryMock!
    private var navigationState: JokeNavigationState!
    
    override func setUp() async throws {
        jokeRepository = JokeRepositoryMock()
        navigationState = JokeNavigationState()
        
        viewModel = JokeListViewModel(
            jokeRepository: jokeRepository,
            navigationState: navigationState
        )
    }
    
    func testInitialData() async {
        jokeRepository.returnValue = [.mock]
        await viewModel.prepare()
        
        XCTAssertEqual(viewModel.state.dataState, .data([.mock]))
    }
    
    func testNoInitialData() async {
        jokeRepository.returnValue = []
        await viewModel.prepare()
        
        XCTAssertEqual(viewModel.state.dataState, .empty)
    }
    
    func testErrorGettingInitialData() async {
        jokeRepository.error = NetworkError.unknown
        await viewModel.prepare()
        
        XCTAssertEqual(viewModel.state.dataState, .empty)
    }
    
    func testViewModelLoadingState() async {
        jokeRepository.returnValue = [.mock]
        
        XCTAssertEqual(viewModel.state.isLoading, false)
        await self.viewModel.fetchJokes()
        XCTAssertEqual(self.viewModel.state.isLoading, false)
    
        XCTAssertEqual(jokeRepository.loadJokesCalled, true)
    }
    
    func testJokeSelection() async {
        XCTAssertEqual(navigationState.routes.isEmpty, true)
        viewModel.didSelectJoke(joke: .mock)
        XCTAssertEqual(navigationState.routes, [.mock])
    }
}
