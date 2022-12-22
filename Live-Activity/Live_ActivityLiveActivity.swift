//
//  Live_ActivityLiveActivity.swift
//  Live-Activity
//
//  Created by Erik Bye on 12/20/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Live_ActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var timerRange: ClosedRange<Date>
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LiveActivityNotificationView: View {
    let timerRange: ClosedRange<Date>
    var body: some View {
        HStack(spacing: 20) {
            ZStack{
                CircularProgressView(progress: 0.5, lineWidth: 6)
                            .frame(width: 50, height: 50)
                Text(timerInterval: timerRange, countsDown: true)
                    .monospacedDigit()
                    .foregroundColor(Color.white)
                    .frame(width: 40)
                    .multilineTextAlignment(.center)
            }
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("21m ahead")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color.green))
                }
                Text("Current Order Item Title")
                    .foregroundColor(.white)
                    .font(.title)
                Text("NEXT - 3:45")
                    .foregroundColor(.gray)
                    .font(.callout)
                Text("Order Item Title")
                    .foregroundColor(.gray)
                    .font(.callout)
                
            }
        }
        .padding(10)
    }
}

struct Live_ActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Live_ActivityAttributes.self) { context in
            LiveActivityNotificationView(timerRange: context.state.timerRange)
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    ExpandedLeadingView(progress: 0.5, timerRange: context.state.timerRange)
                }
                DynamicIslandExpandedRegion(.trailing, priority: 1) {
                    ExpandedTrailingView()
                }
            } compactLeading: {
                CompactLeadingView(progress: 0.5)
            } compactTrailing: {
                CompactTrailingView(timerRange: context.state.timerRange)
            } minimal: {
                MinimalView()
            }
            .keylineTint(Color.orange)
        }
    }
}

struct ExpandedLeadingView: View {
    var progress: CGFloat
    let timerRange: ClosedRange<Date>
    var body: some View {
                ZStack{
                    CircularProgressView(progress: progress, lineWidth: 6)
                                .frame(width: 90, height: 90)
                    Text(timerInterval: timerRange, countsDown: true)
                        .font(.body)
                        .monospacedDigit()
                        .foregroundColor(Color.white)
                        .frame(width: 40)
                        .multilineTextAlignment(.center)
                }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ExpandedTrailingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("21m ahead")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.green))
            }
            Text("Current Order Item Title")
                .foregroundColor(.white)
                .font(.title)
            Text("NEXT - 3:45")
                .foregroundColor(.gray)
                .font(.callout)
            Text("Order Item Title")
                .foregroundColor(.gray)
                .font(.callout)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dynamicIsland(verticalPlacement: .belowIfTooWide)
    }
}

struct CompactLeadingView: View {
    var progress: CGFloat
    var body: some View {
        ZStack{
            CircularProgressView(progress: progress, lineWidth: 3)
                        .frame(width: 24, height: 24)
            Image("services-icon")
                .resizable()
                .frame(width: 15, height: 15)
        }
        .padding(1)
    }
}

struct CompactTrailingView: View {
    let timerRange: ClosedRange<Date>
    var body: some View {
        Text(timerInterval: timerRange, countsDown: true)
            .monospacedDigit()
            .foregroundColor(Color.white)
            .frame(width: 40)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green))
            .multilineTextAlignment(.center)
    }
}

struct MinimalView: View {
    var body: some View {
        ZStack{
            CircularProgressView(progress: 0.5, lineWidth: 3)
                        .frame(width: 24, height: 24)
            Image("services-icon")
                .resizable()
                .frame(width: 15, height: 15)
        }
        .padding(1)
    }
}

struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.green.opacity(0.5),
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.green,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

struct Live_ActivityLiveActivity_Previews: PreviewProvider {
    static let attributes = Live_ActivityAttributes(name: "Me")
    static let contentState = Live_ActivityAttributes.ContentState(
        timerRange: Date.now...Date(timeIntervalSinceNow: 30))

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
