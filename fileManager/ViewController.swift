//
//  ViewController.swift
//  file_manager
//
//  Created by Ярослав  Мартынов on 26.05.2024.
//

import UIKit

class ViewController: UIViewController{
    
    var content: Content = Content(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    
    var fileManager: FileManagerServiceProtocol = FileManagerService()
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        tuneView()
        addSubviews()
        setupConstraints()
        tuneTableView()
    }
    
    private func tuneView() {
        view.backgroundColor = .white
        let createFolderButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(didTabCreateFolder))
        let addImageButton = UIBarButtonItem(image:UIImage(systemName: "plus") , style: .plain, target: self, action: #selector(didTabAddImage))
        navigationItem.rightBarButtonItems = [addImageButton, createFolderButton]
        title = content.title
    }
    
    
    @objc private func didTabCreateFolder(){
        TextPicker.showMessageAddFolder(in: self){ [weak self] text in
            guard let self else {return}
            fileManager.createDirectory(path: self.content.path, name: text)
            tableView.reloadData()
        }
        
    }
    
    @objc private func didTabAddImage(){
        presentImagePicker()
    }
    
    

    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    
    
    
    
    
    private func tuneTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func presentImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileManager.contentsOfDirectory(path: content.path).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        config.text = fileManager.contentsOfDirectory(path: content.path)[indexPath.row]
        cell.contentConfiguration = config
        cell.accessoryType = fileManager.isPatchForItemIsFolder(path: content.path, name: fileManager.contentsOfDirectory(path: content.path)[indexPath.row]) ? .disclosureIndicator : .none
        return cell
    }
    
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileManager.removeContent(path: content.path, nameDeleteItem: fileManager.contentsOfDirectory(path: content.path)[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fileManager.isPatchForItemIsFolder(path: content.path, name: fileManager.contentsOfDirectory(path: content.path)[indexPath.row]) {
            let vc = ViewController()
            vc.content = Content(path: content.path + "/" + fileManager.contentsOfDirectory(path: content.path)[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            fileManager.createFile(path: content.path, image: pickedImage)
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}
