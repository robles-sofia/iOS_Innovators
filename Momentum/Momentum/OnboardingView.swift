//
//  OnboardingView.swift
//  Momentum
//
//  Created by Brandon Baker on 4/13/26
//

import SwiftUI

// model used for each onboarding question
// makes it easy to loop through questions in the UI
struct OnboardingQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
}

struct OnboardingView: View {
    
    // saves onboarding completion and username so it persists after app closes
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("savedUserName") private var savedUserName = ""

    // user input + progress tracking
    @State private var userName: String = ""
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedAnswers: [Int?] = Array(repeating: nil, count: 5)
    @State private var showFeedback = false

    // list of onboarding questions with multiple choice answers
    private let questions: [OnboardingQuestion] = [
        OnboardingQuestion(
            question: "What best describes your biggest strength?",
            options: [
                "Staying motivated",
                "Being organized",
                "Finishing what I start",
                "Bouncing back after a bad day"
            ]
        ),
        OnboardingQuestion(
            question: "What is your biggest challenge right now?",
            options: [
                "Staying consistent",
                "Managing my time",
                "Avoiding distractions",
                "Starting tasks"
            ]
        ),
        OnboardingQuestion(
            question: "What is your main goal?",
            options: [
                "Build healthier habits",
                "Be more productive",
                "Improve discipline",
                "Reduce stress"
            ]
        ),
        OnboardingQuestion(
            question: "What motivates you most?",
            options: [
                "Seeing progress",
                "Feeling healthier",
                "Reaching goals",
                "Proving to myself I can do it"
            ]
        ),
        OnboardingQuestion(
            question: "How confident are you that you can stay on track this week?",
            options: [
                "Very confident",
                "Somewhat confident",
                "Not very confident",
                "I’m just getting started"
            ]
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                
                // background gradient for cleaner look
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color.green.opacity(0.10)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // switches between questions and feedback screen
                if showFeedback {
                    feedbackView
                } else {
                    questionView
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // main question screen
    private var questionView: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // app intro text
                Text("Welcome to Momentum")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Let’s get to know you a little better.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // name input section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Name")
                        .font(.headline)

                    TextField("Enter your name", text: $userName)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                // question + answers section
                VStack(alignment: .leading, spacing: 16) {
                    
                    // shows progress (question number)
                    Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // displays current question
                    Text(questions[currentQuestionIndex].question)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    // answer options
                    ForEach(questions[currentQuestionIndex].options.indices, id: \.self) { index in
                        Button {
                            selectedAnswers[currentQuestionIndex] = index
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                
                                // selection circle
                                Image(systemName: selectedAnswers[currentQuestionIndex] == index ? "largecircle.fill.circle" : "circle")
                                    .foregroundStyle(selectedAnswers[currentQuestionIndex] == index ? .green : .gray)
                                    .padding(.top, 2)

                                Text(questions[currentQuestionIndex].options[index])
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)

                                Spacer()
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 22))

                // navigation buttons (Back / Next)
                HStack {
                    if currentQuestionIndex > 0 {
                        Button("Back") {
                            currentQuestionIndex -= 1
                        }
                        .buttonStyle(.bordered)
                    }

                    Spacer()

                    Button {
                        if currentQuestionIndex < questions.count - 1 {
                            currentQuestionIndex += 1
                        } else {
                            showFeedback = true
                        }
                    } label: {
                        Text(currentQuestionIndex == questions.count - 1 ? "See Feedback" : "Next")
                            .frame(minWidth: 110)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // disables button if name is empty or no answer selected
                    .disabled(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedAnswers[currentQuestionIndex] == nil)
                }

                Spacer(minLength: 20)
            }
            .padding()
        }
    }

    // feedback screen after finishing questions
    private var feedbackView: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundStyle(.green)

                Text("Your Momentum Plan")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Thanks, \(userName.isEmpty ? "User" : userName)!")
                    .font(.title3)
                    .fontWeight(.semibold)

                // generated personalized feedback
                Text(generateFeedback())
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                // saves data and finishes onboarding
                Button {
                    savedUserName = userName
                    hasCompletedOnboarding = true
                } label: {
                    Text("Start Using Momentum")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Spacer(minLength: 20)
            }
            .padding()
        }
    }

    // generates personalized feedback based on user answers
    private func generateFeedback() -> String {
        let strengthIndex = selectedAnswers[0] ?? 0
        let challengeIndex = selectedAnswers[1] ?? 0
        let goalIndex = selectedAnswers[2] ?? 0
        let motivationIndex = selectedAnswers[3] ?? 0
        let confidenceIndex = selectedAnswers[4] ?? 0

        let strengthText = questions[0].options[strengthIndex]
        let challengeText = questions[1].options[challengeIndex]
        let goalText = questions[2].options[goalIndex]
        let motivationText = questions[3].options[motivationIndex]
        let confidenceText = questions[4].options[confidenceIndex]

        var feedback = "You already have a strong foundation because one of your strengths is \(strengthText.lowercased()). "

        // builds feedback based on selected answers
        if challengeText == "Staying consistent" {
            feedback += "Since consistency is your biggest challenge, start small so it feels easier to stay on track. "
        } else if challengeText == "Managing my time" {
            feedback += "Since time management is your biggest challenge, try doing habits at the same time each day. "
        } else if challengeText == "Avoiding distractions" {
            feedback += "Since distractions are an issue, try doing habits in a quiet space. "
        } else {
            feedback += "Since getting started is the hardest part, focus on small first steps. "
        }

        if goalText == "Build healthier habits" {
            feedback += "Focus on habits like water, walking, or better sleep. "
        } else if goalText == "Be more productive" {
            feedback += "Try habits like planning your day or limiting distractions. "
        } else if goalText == "Improve discipline" {
            feedback += "Daily check-ins and streak tracking will help build discipline. "
        } else {
            feedback += "Focus on calming habits like journaling or meditation. "
        }

        if motivationText == "Seeing progress" {
            feedback += "Tracking your streak should help keep you motivated. "
        } else if motivationText == "Feeling healthier" {
            feedback += "Habits that improve your routine will feel rewarding. "
        } else if motivationText == "Reaching goals" {
            feedback += "Focus on small daily wins to stay on track. "
        } else {
            feedback += "You have a strong mindset to keep improving over time. "
        }

        if confidenceText == "Very confident" {
            feedback += "You’re in a great spot to stay consistent this week."
        } else if confidenceText == "Somewhat confident" {
            feedback += "Keep habits realistic to build a strong streak."
        } else if confidenceText == "Not very confident" {
            feedback += "Start small and build confidence through consistency."
        } else {
            feedback += "Focus on progress, not perfection as you get started."
        }

        return feedback
    }
}
