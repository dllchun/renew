# Mental Health "Savings Account" App Requirements

## **Pages**

### **1. Onboarding Page**
- **Description**: Introduce the app's concept and guide new users through its core features. This page ensures new users understand how the "Mental Health Savings Account" works and motivates them to start using the app.
- **Checklist**:
  - Provide an engaging overview of the "Mental Health Savings Account" concept (e.g., animations or illustrations).
  - Include concise, user-friendly instructions on how to earn and spend points.
  - Prompt users to log their first activity (e.g., sleep or exercise) with a guided flow.
  - Award points for the first logged activity to create a positive first impression.
  - Ensure the page follows best practices for onboarding:
    - Minimal text with clear visuals.
    - Use interactive, step-by-step instructions.
    - Progress indicators for multi-step onboarding.
- **Example**:
  - Step 1: "Welcome! Track your mental health like a bank account."
  - Step 2: "Log your first activity: Did you sleep 8+ hours last night?"
  - Step 3: "Great start! You’ve earned your first 10 points."

---

### **2. Dashboard Page**
- **Description**: The central hub for users to view their mental health balance and track their progress over time.
- **Checklist**:
  - Display the **current balance** in mental health points (MHP).
  - Show **daily earnings and spending** (e.g., activities logged).
  - Include a **weekly progress chart** to visualize balance changes over time.
  - Display motivational insights or recommendations based on user trends.
  - Follow mobile UX/UI best practices:
    - Use a clean, uncluttered layout with a focus on key information (balance, earnings, and trends).
    - Ensure high contrast between text and background for readability.
    - Use animations or transitions to enhance interactions (e.g., chart updates).
    - Include tappable cards or icons for quick navigation to activity logs or insights.
- **Example**:
  - Current balance: "Your balance is **120 Mental Health Points**."
  - Earnings today: "+20 points (8 hours of sleep, mindfulness session)."
  - Spending today: "-10 points (skipped lunch, overworked)."
  - Weekly trend: A line chart with increasing or decreasing balance.

---

### **3. Activity Tracker Page**
- **Description**: Allow users to log daily activities that impact their mental health balance. Activities are predefined as either "earning" or "spending" points.
- **Checklist**:
  - Display a predefined list of **earning activities** (e.g., sleep, exercise) and **spending activities** (e.g., overwork, skipping meals).
  - Allow users to log activities by selecting from the list.
  - Automatically update the balance in real-time after an activity is logged.
  - Provide clear feedback on how the activity impacted their balance.
  - Follow mobile UX/UI best practices:
    - Use tappable cards or buttons for activities with clear labels/icons.
    - Ensure list items dynamically adjust to screen size and orientation.
    - Use confirmation dialogs or toasts when activities are logged.
    - Add subtle animations for logged activities (e.g., point updates).
- **Example**:
  - Earning Activity: "Slept 8+ hours" → +10 points.
  - Spending Activity: "Skipped a meal" → -5 points.
  - System Response: "Your new balance is **123 points**."

---

### **4. Daily Check-In Page**
- **Description**: A simple form where users reflect on their mood, energy levels, and stress triggers. Completing the check-in earns them points for consistency.
- **Checklist**:
  - Include the following fields:
    - **Mood Tracker**: An emoji slider (😊 😐 😞) for users to select their mood.
    - **Energy Level**: A numeric scale (1–10) for users to indicate their energy level.
    - **Stress Triggers**: A list of predefined categories (e.g., work, family, health).
  - Award points (e.g., +2 points) for completing the check-in.
  - Save check-in data to Firestore (`users/{userId}/checkins`) for future analysis.
  - Follow mobile UX/UI best practices:
    - Ensure fields are spaced and sized appropriately for touch interaction.
    - Use descriptive placeholders or labels for inputs.
    - Add progress indicators for multi-step check-ins (if applicable).
    - Ensure form elements (e.g., sliders, dropdowns) are accessible and responsive.
- **Example**:
  - User logs:
    - Mood: 😐 (Neutral).
    - Energy: 6/10.
    - Stress Trigger: "Work deadlines."
  - System Response: "Great job reflecting today! You earned **+2 points**."

---

### **5. Gamification Page (Achievements)**
- **Description**: Showcase streaks, badges, and achievements to motivate users to stay engaged and maintain positive habits.
- **Checklist**:
  - Display **current streaks**: Number of consecutive days users logged activities or completed check-ins.
  - Showcase **unlocked badges** for specific milestones:
    - Example: "Mindfulness Master: Logged 10 meditation sessions."
  - Highlight major **achievements**:
    - Example: "You reached 500 total points!"
  - Follow mobile UX/UI best practices:
    - Use visually appealing badge designs with animations or progress bars.
    - Ensure streaks and milestones are organized in a clean, scrollable layout.
    - Provide motivational captions or feedback for achievements.

---

### **6. Settings Page**
- **Description**: Allow users to manage their profile and app preferences.
- **Checklist**:
  - Manage **profile information** (e.g., name, email).
  - Adjust **notification settings** (e.g., enable/disable reminders and motivational messages).
  - Provide an option to **reset streaks or logs** if necessary.
  - Follow mobile UX/UI best practices:
    - Use a clear and simple layout for toggles and inputs.
    - Group related settings into collapsible sections if needed.
    - Add confirmation dialogs for irreversible actions (e.g., resetting logs).

---

## **Folder Structure Guidelines**
- Use a **very clean and scalable folder structure** for modularity:


---

## **Scalability Guidelines**
1. Use **Riverpod** or Provider for state management.
2. Create **reusable widgets** for:
 - Buttons, cards, sliders, and progress bars.
 - Charts (e.g., weekly trend charts).
3. Centralize and dynamically configure:
 - **Colors, fonts, dimensions, and spacings** in a theme file (`shared/utils/theme.dart`).
 - Example: Define reusable constants like `primaryColor`, `smallPadding`, `cardBorderRadius`.
4. Optimize Firestore queries for performance.
5. Ensure all screens follow **responsive design principles** for different screen sizes.

---

## **Non-Functional Requirements**
- **Performance**: App should load dashboards and log activities in under 2 seconds.
- **Scalability**: Use Firebase for backend to handle growing user data.
- **Security**: Use Firebase Authentication for secure user login.
- **Accessibility**: Ensure the app is accessible for users with disabilities (e.g., voice-over support, proper contrast ratios).

---

### **UI Design Style**
Develop the app following the visual style and design principles shown in the provided image. Ensure the app design incorporates the following elements:

1. **Soft and Friendly Visuals**:
   - Use **rounded corners** for all cards, buttons, and containers.
   - Apply a **soft color palette** with light and pastel tones (e.g., beige, green, yellow, and brown).
   - Incorporate **subtle gradients** or background patterns for depth while keeping the interface clean.

2. **Typography**:
   - Use a **modern, sans-serif font** with clear and legible text.
   - Employ **hierarchical typography**:
     - Large and bold headings for key metrics or prompts.
     - Smaller, lighter text for secondary information.

3. **Icons and Imagery**:
   - Use **minimalistic and rounded icons** for navigation and actions.
   - Include **emoji-like visuals** for user interactions (e.g., mood sliders, feedback screens).
   - Add subtle illustrations where appropriate to make the app feel friendly and inviting.

4. **Interactive Elements**:
   - Buttons and sliders should:
     - Be **large and tappable**, with clear feedback on interaction (e.g., ripple effects or subtle scaling animations).
     - Use bold, contrasting colors for primary actions (e.g., "Set Mood," "Create Journal").
   - Incorporate **floating action buttons (FABs)** for key actions, such as adding entries or navigating.

5. **Charts and Visual Data**:
   - Use **rounded line charts** or bar charts to display trends (e.g., mood history or mental health metrics).
   - Ensure all charts are visually appealing with soft edges and dynamic transitions.

6. **White Space and Layout**:
   - Maintain **ample white space** to avoid clutter and ensure focus on important elements.
   - Use **card-based layouts** for grouping content (e.g., mood history, recommendations).

7. **Transitions and Animations**:
   - Add **smooth transitions** for page navigation, modal openings, and data updates.
   - Use **micro-interactions** for feedback, such as button presses, mood selection, or activity logging.

8. **Accessibility**:
   - Ensure sufficient **contrast ratios** for readability.
   - All interactive elements should follow **touch-friendly guidelines** (e.g., minimum 48x48px tappable areas).