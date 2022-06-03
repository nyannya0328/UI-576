//
//  Home.swift
//  UI-576
//
//  Created by nyannyan0328 on 2022/06/03.
//

import SwiftUI

struct Home: View {
    @Namespace var animation
    @State var expandedProFile : Profile?
    
    @State var isExpanded : Bool = false
    
    @State var loadExpandedContent : Bool = false
    
    @State var offset : CGSize = .zero
    var body: some View {
        NavigationView{
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing:15){
                    
                    
                    ForEach(profiles){pro in
                        
                        
                        CardView(pro: pro)
                        
                    }
                    .padding()
                    
                    
                }
            }
            .navigationTitle("Whats Up")
            
        }
          .frame(maxWidth: .infinity,alignment: .center)
        .overlay(content: {
            
            Rectangle()
                .fill(.black)
                .opacity(loadExpandedContent ? 1 : 0)
                .opacity(offsetProgress())
                .ignoresSafeArea()
        })
        .overlay {
            
            if let expandedProFile = expandedProFile,isExpanded {
                
                
                ExpandedView(pro: expandedProFile)
            }
        }
    }
    
    func offsetProgress()->CGFloat{
        
        let progress = offset.height / 100
        
        
        if offset.height < 0{
            
            return 1
            
        }
        else{
            
            return 1 - (progress < 1 ? progress : 1)
        }
        
    }
    
    @ViewBuilder
    func ExpandedView(pro : Profile)->some View{
        
        VStack{
            
            GeometryReader{proxy in
                
                
                 let size = proxy.size
                
                
                Image(pro.profilePicture)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(loadExpandedContent ? 0 : size.height)
                    .offset(y: loadExpandedContent ? offset.height : .zero)
                    .gesture(
                    
                    
                    
                        DragGesture().onChanged({ value in
                            
                            offset = value.translation
                            
                        })
                        .onEnded({ value in
                            
                            
                            let height = value.translation.height
                            
                            if height > 0 && height > 100{
                                
                                
                                withAnimation(.easeInOut(duration: 0.4)){
                                    
                                    loadExpandedContent = false
                                }
                                
                                
                                withAnimation(.easeInOut(duration: 0.4).delay(0.05)){
                                    
                                    isExpanded = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    
                                    
                                    offset = .zero
                                }
                                
                                
                                
                            }
                            else if height < 0 && height < 100{
                                
                                withAnimation(.easeInOut(duration: 0.4)){
                                    
                                    loadExpandedContent = false
                                }
                                
                                
                                withAnimation(.easeInOut(duration: 0.4).delay(0.05)){
                                    
                                    isExpanded = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    
                                    
                                    offset = .zero
                                }
                                
                                
                             
                            }
                            
                            else{
                                
                                offset = .zero
                                
                            }
                            
                        })
                    
                    
                    )
            }
            .matchedGeometryEffect(id: pro.id, in: animation)
            .frame(height: 300)
           
        }
        .frame(maxWidth: .infinity,maxHeight:.infinity,alignment: .center)
        .overlay(alignment: .top, content: {
            
            
            HStack{
                
              
                
                
                Button {
                    
                    withAnimation(.easeInOut(duration: 4)){
                        
                        loadExpandedContent = false
                    }
                    
                    withAnimation(.easeInOut(duration: 4).delay(0.05)){
                        
                        isExpanded = false
                    }
                    
                    
                } label: {
                    
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        
                    
                    Text(pro.userName)
                        .font(.caption2.weight(.semibold))
                    
                    
                }
                .foregroundColor(.white)
                
                Spacer(minLength: 10)

                
                
            }
            .padding()
            .opacity(loadExpandedContent ? 1 : 0)
            .opacity(offsetProgress())
            
        })
        .transition(.offset(x: 0, y: 1))
        .onAppear {
            
            withAnimation(.easeInOut(duration: 4)){
                
                loadExpandedContent = true
            }
        }
        
        
    }
    @ViewBuilder
    func CardView(pro : Profile)->some View{
        
        HStack{
            
            VStack{
                if expandedProFile?.id == pro.id && isExpanded{
                    
                    
                    Image(pro.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .cornerRadius(0)
                        .opacity(0)
                    
                }
                else{
                    
                    
                    Image(pro.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .cornerRadius(25)
                        .matchedGeometryEffect(id: pro.id, in: animation)
                }
            }
            .onTapGesture {
                
                withAnimation(.easeInOut(duration: 4)){
                    
                    expandedProFile = pro
                    isExpanded = true
                }
                
             
            }
            
            VStack(alignment: .leading, spacing: 13) {
                
                
                Text(pro.userName)
                    .font(.title3.weight(.bold))
                
                Text(pro.lastMsg)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gray)
                
                
                
            }
              .frame(maxWidth: .infinity,alignment: .leading)
            
            Text(pro.lastActive)
                .font(.callout.weight(.light))
                .foregroundColor(.gray)
            
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
