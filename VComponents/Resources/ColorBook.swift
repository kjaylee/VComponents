//
//  ColorBook.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- Color Book
public struct ColorBook {
    private init() {}
}

// MARK:- Primary Button
extension ColorBook {
    public struct PrimaryButton {
        public struct Text {
            public static let enabled: Color = .init(.s255, .s255, .s255, .o100)
            public static let pressed: Color = enabled
            public static let disabled: Color = .init(.s255, .s255, .s255, .o50)
            public static let loading: Color = disabled
            
            private init() {}
        }
        
        public struct Fill {
            public static let enabled: Color = .init(.s48, .s128, .s224, .o100)
            public static let pressed: Color = .init(.s32, .s96, .s160, .o100)
            public static let disabled: Color = .init(.s128, .s176, .s240, .o100)
            public static let loading: Color = disabled
            
            private init() {}
        }
        
        public struct Border {
            public static let enabled: Color = Fill.disabled
            public static let pressed: Color = Fill.disabled
            public static let disabled: Color = Fill.disabled
            public static let loading: Color = Fill.disabled
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Plain Button
extension ColorBook {
    public struct PlainButton {
        public struct Text {
            public static let enabled: Color = .init(.s16, .s112, .s255, .o100)
            public static let pressed: Color = enabled
            public static let disabled: Color = .init(.s128, .s176, .s255, .o100)
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Circular Button
extension ColorBook {
    public struct CircularButton {
        public struct Fill {
            public static let enabled: Color = PrimaryButton.Fill.enabled
            public static let pressed: Color = PrimaryButton.Fill.pressed
            public static let disabled: Color = PrimaryButton.Fill.disabled
            
            private init() {}
        }
        
        public struct Text {
            public static let enabled: Color = PrimaryButton.Text.enabled
            public static let pressed: Color = PrimaryButton.Text.pressed
            public static let disabled: Color = PrimaryButton.Text.disabled
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Toggle
extension ColorBook {
    public struct Toggle {
        public struct Fill {
            public static let enabledOn: Color = PrimaryButton.Fill.enabled
            public static let enabledOff: Color = .init(.s224, .s224, .s224, .o100)
            public static let disabled: Color = .init(.s208, .s208, .s208, .o100)
            
            private init() {}
        }
        
        public struct Thumb {
            public static let enabledOn: Color = PrimaryButton.Text.enabled
            public static let enabledOff: Color = enabledOn
            public static let disabled: Color = enabledOn
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Slider
extension ColorBook {
    public struct Slider {
        public struct Track {
            public static let enabled: Color = .init(.s224, .s224, .s224, .o100)
            public static let disabled: Color = .init(.s240, .s240, .s240, .o100)
            
            private init() {}
        }
        
        public struct Shadow {
            public static let enabled: Color = .init(.s96, .s96, .s96, .o50)
            public static let disabled: Color = .init(.s96, .s96, .s96, .o20)
            
            private init() {}
        }
        
        public struct Progress {
            public static let enabled: Color = Toggle.Fill.enabledOn
            public static let disabled: Color = Toggle.Fill.disabled
            
            private init() {}
        }
        
        public struct Thumb {
            public static let enabled: Color = PrimaryButton.Text.enabled
            public static let disabled: Color = enabled
            
            private init() {}
        }
        
        public struct ThumbStroke {
            public static let enabled: Color = .init(.s96, .s96, .s96, .o100)
            public static let disabled: Color = .init(.s192, .s192, .s192, .o100)
            
            private init() {}
        }
        
        private init() {}
    }
}

// MARK:- Spinner
extension ColorBook {
    public struct Spinner {
        public static let fill: Color = PrimaryButton.Text.enabled
        
        private init() {}
    }
}

// MARK:- Helper
private extension Color {
    init(_ r: ColorBook.Shade, _ g: ColorBook.Shade, _ b: ColorBook.Shade, _ a: ColorBook.Opacity) {
        self.init(red: r.rawValue, green: g.rawValue, blue: b.rawValue, opacity: a.rawValue)
    }
}

private extension ColorBook {
    enum Shade: Double {
        case s0 = 0.0
        case s16 = 0.06274509804
        case s32 = 0.1254901961
        case s48 = 0.1882352941
        case s64 = 0.2509803922
        case s80 = 0.3137254902
        case s96 = 0.3764705882
        case s112 = 0.4392156863
        case s128 = 0.5019607843
        case s144 = 0.5647058824
        case s160 = 0.6274509804
        case s176 = 0.6901960784
        case s192 = 0.7529411765
        case s208 = 0.8156862745
        case s224 = 0.8784313725
        case s240 = 0.9411764706
        case s255 = 1.0
    }
    
    enum Opacity: Double {
        case o0 = 0.0
        case o10 = 0.1
        case o20 = 0.2
        case o30 = 0.3
        case o40 = 0.4
        case o50 = 0.5
        case o60 = 0.6
        case o70 = 0.7
        case o80 = 0.8
        case o90 = 0.9
        case o100 = 1.0
    }
}
