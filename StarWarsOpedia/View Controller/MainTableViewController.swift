import UIKit
import Alamofire

class MainTableViewController: UITableViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  var items: [Displayable] = []
  var films: [Film] = []

  var selectedItem: Displayable?

  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    fetchFilms()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
    let item = items[indexPath.row]
    cell.textLabel?.text = item.titleLabelText
    cell.detailTextLabel?.text = item.subtitleLabelText
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedItem = items[indexPath.row]
    return indexPath

  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? DetailViewController else {
      return
    }
    destinationVC.data = selectedItem

  }
}

// MARK: - UISearchBarDelegate
extension MainTableViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let shipName = searchBar.text else { return }
    searchStarships(for: shipName)

  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    searchBar.resignFirstResponder()
    items = films
    tableView.reloadData()
  }
}

extension MainTableViewController {
  func fetchFilms() {
    // 1
    let request = AF.request("https://swapi.dev/api/films")
    // 2
    request.responseDecodable(of: Films.self) { (response) in
      guard let films = response.value else { return }
      self.items = films.all
      self.films = films.all

      self.tableView.reloadData()
    }
  }
  func searchStarships(for name: String) {
    // 1
    let url = "https://swapi.dev/api/starships"
    // 2
    let parameters: [String: String] = ["search": name]
    // 3
    AF.request(url, parameters: parameters)
      .validate()
      .responseDecodable(of: Starships.self) { response in
        // 4
        guard let starships = response.value else { return }
        self.items = starships.all
        self.tableView.reloadData()
    }
  }
}
