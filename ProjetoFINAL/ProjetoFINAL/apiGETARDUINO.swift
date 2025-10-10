//
//  urlView.swift
//  Desafio07
//
//  Created by Turma02-1 on 19/09/25.
//

import SwiftUI
import Foundation

class apiGETARDUINO: ObservableObject {
    @Published var sinais: [sinal] = []
    func fetch(){
        guard let url = URL(string:"http://127.0.0.1:1880/arduGET")else{
            return
        }
        let task=URLSession.shared.dataTask(with:url){[weak self] data, _, error in
            guard let data=data, error==nil else{
                return
            }
            do{
                let parsed = try JSONDecoder().decode([sinal].self, from:data)
                DispatchQueue.main.async{
                    self?.sinais = parsed
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}

