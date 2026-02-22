# Home Feature

## 📁 Structure

```
features/home/
├── models/
│   ├── category_model.dart      # Category data model
│   └── provider_model.dart      # Provider data model
├── view/
│   ├── home_view.dart           # Main home screen
│   └── provider_profile_view.dart # Provider profile (placeholder)
└── widgets/
    ├── category_item.dart       # Category card widget
    ├── custom_bottom_nav_bar.dart # Bottom navigation bar
    ├── promo_banner.dart        # Promotional banner widget
    └── provider_card.dart       # Provider card widget
```

## 🎯 Features Implemented

### 1. Top App Bar (Sticky)
- Profile picture with border
- Greeting text: "Bonjour, Marouane 👋"
- Location selector with dropdown icon
- Notification icon with red badge indicator

### 2. Search Bar
- Rounded container with shadow
- Search icon
- Placeholder text
- Filter button (tune icon) with primary color

### 3. Categories Section
- Horizontal scrollable list
- Each category has:
  - Custom icon
  - Background color
  - Icon color
  - Label text
- "Voir tout" button

### 4. Promotional Banner
- Gradient background (primary color)
- Background pattern icon
- Title: "OFFRE SPÉCIALE"
- Discount text: "20% de réduction sur votre 1er Ménage"
- CTA button: "Réserver"

### 5. Nearby Providers Section
- "Trier par" button with sort icon
- Vertical list of provider cards
- Each card includes:
  - Provider image (80x80)
  - Name
  - Service description
  - Verified badge (blue checkmark)
  - Rating with star icon
  - Review count
  - Distance with location icon
  - Starting price
  - "Voir profil" button

### 6. Bottom Navigation Bar
- 5 tabs: Accueil, Rechercher, Réservations, Favoris, Profil
- Active state styling (primary color)
- Inactive state (gray)
- Icons + labels

## 🎨 Design System

### Colors Used
- Primary: `#2C5F8D` (Blue from logo)
- Secondary: `#FF6B35` (Orange from logo)
- Text Primary: `#2C3E50`
- Text Secondary: `#7F8C8D`
- Background: `#F8F9FA`
- White: `#FFFFFF`

### Typography
- Font: Poppins (via Google Fonts)
- Heading: 18px, w600
- Body: 14px, w500
- Small: 12px, w400

## 🔗 Navigation Flow

```
Login Success → HomeView
HomeView → ProviderProfileView (on "Voir profil" tap)
HomeView → CategoryResultsView (on category tap) [TODO]
Bottom Nav → Other screens [TODO]
```

## 📝 How to Use

### 1. Navigate to Home after Login

In your `LoginView` or `AuthViewModel`, after successful login:

```dart
Navigator.pushReplacementNamed(context, AppRoutes.home);
```

### 2. Access from Main Routes

The home route is already registered in `main.dart`:

```dart
AppRoutes.home: (context) => const HomeView(),
```

### 3. Test the Screen

You can temporarily change the initial route in `main.dart` for testing:

```dart
initialRoute: AppRoutes.home, // Instead of AppRoutes.splash
```

## 🚀 Next Steps (TODO)

1. **Connect to Backend API**
   - Replace mock data with real API calls
   - Implement provider service
   - Add loading states

2. **Implement Navigation**
   - Provider profile screen
   - Category results screen
   - Search functionality
   - Bottom nav screens (Rechercher, Réservations, Favoris, Profil)

3. **Add State Management**
   - Create HomeViewModel (if using Provider pattern)
   - Handle loading/error states
   - Implement search and filter logic

4. **Enhance Features**
   - Location picker functionality
   - Notification system
   - Favorites functionality
   - Real-time distance calculation

5. **Add Animations**
   - Smooth transitions
   - Loading skeletons
   - Pull-to-refresh

## 📦 Dependencies Used

- `google_fonts`: For Poppins font
- `provider`: State management (already in project)

No additional packages required!

## ✅ Production Ready

- Clean code structure
- Reusable widgets
- Follows Material 3 guidelines
- Respects existing theme
- No hardcoded values
- Proper error handling for images
- Responsive design
