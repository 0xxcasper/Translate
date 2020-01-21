//
//  SettingViewController.swift
//  TextToSpeak
//
//  Created by admin on 30/12/2019.
//  Copyright © 2019 SangNX. All rights reserved.
//

import UIKit
import AVFoundation

enum SectionType: String {
    case voice = "VOICE"
    case setting = "SETTINGS"
    case other = "OTHER"
}

enum SettingType {
    case normal
    case control
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tbView: UITableView!
    let synthesizer = AVSpeechSynthesizer()
    var sections = [SectionType.voice]
    var voices = [SettingType.normal, SettingType.control, SettingType.control]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cài đặt"
        setUpTableViews()
    }
    
    private func setUpTableViews() {
        tbView.separatorStyle = .none
        tbView.registerXibFile(NormalTableViewCell.self)
        tbView.registerXibFile(ControlTableViewCell.self)
        tbView.dataSource = self
        tbView.delegate = self
    }
    
    func reloadData() {
        tbView.reloadData()
    }
}

extension SettingViewController : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .voice:
            return voices.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .voice:
            switch voices[indexPath.row] {
            case .normal:
                let cell = tbView.dequeue(NormalTableViewCell.self, for: indexPath)
                cell.setupCell()
                return cell
            default:
                let cell = tbView.dequeue(ControlTableViewCell.self, for: indexPath)
                cell.delegate = self
                cell.type = indexPath.row == 1 ? .rate : .pitch
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0 && indexPath.row == 0) {
            let vc = ListVoiceViewController()
            vc.mContext = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = HeaderCell()
        headerCell.lbl.text = sections[section].rawValue
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension SettingViewController: ControlTableViewCellDelegate {
    func onChangeSLider() {
        let str = "Welcome to wonderful application"
        let utterance = str.configAVSpeechUtterance()
        if(synthesizer.isSpeaking) { synthesizer.stopSpeaking(at: .immediate) }
        synthesizer.speak(utterance)
    }
}
