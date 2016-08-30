import KsApi
import Library
import SafariServices

internal final class ProjectUpdatesViewController: WebViewController {
  private let viewModel: ProjectUpdatesViewModelType = ProjectUpdatesViewModel()

  internal func configureWith(project project: Project) {
    self.viewModel.inputs.configureWith(project: project)
  }

  internal override func viewDidLoad() {
    super.viewDidLoad()
    self.viewModel.inputs.viewDidLoad()
  }

  internal override func bindStyles() {
    super.bindStyles()

    self.navigationItem.title = Strings.project_menu_buttons_updates()
  }

  internal override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.goToSafariBrowser
      .observeForControllerAction()
      .observeNext { [weak self] in self?.goToSafariBrowser(url: $0) }

    self.viewModel.outputs.goToUpdate
      .observeForControllerAction()
      .observeNext { [weak self] in self?.goToUpdate(forProject: $0, update: $1) }

    self.viewModel.outputs.goToUpdateComments
      .observeForControllerAction()
      .observeNext { [weak self] in self?.goToComments(forUpdate: $0) }

    self.viewModel.outputs.webViewLoadRequest
      .observeForControllerAction()
      .observeNext { [weak self] in self?.webView.loadRequest($0) }
  }

  private func goToComments(forUpdate update: Update) {
    let vc = CommentsViewController.configuredWith(update: update)
    self.navigationController?.pushViewController(vc, animated: true)
  }

  private func goToSafariBrowser(url url: NSURL) {
    let controller = SFSafariViewController(URL: url)
    controller.modalPresentationStyle = .OverFullScreen
    self.presentViewController(controller, animated: true, completion: nil)
  }

  private func goToUpdate(forProject project: Project, update: Update) {
    let vc = UpdateViewController.configuredWith(project: project, update: update)
    self.navigationController?.pushViewController(vc, animated: true)
  }

  internal func webView(webView: WKWebView,
                        decidePolicyForNavigationAction navigationAction: WKNavigationAction,
                                                        decisionHandler: (WKNavigationActionPolicy) -> Void) {
    decisionHandler(self.viewModel.inputs.decidePolicy(forNavigationAction: navigationAction))
  }
}
