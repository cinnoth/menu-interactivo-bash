Feature: Abrir aplicación angular y hacer clic en un enlace del menu
    Scenario: Usuario abre la app y hace clic en 'Learn with Tutorials'
        Given el usuario abre la página Angular
        When el usuario hace clic en 'Learn with Tutorials'
        Then el usuario es redirigido a la página de tutoriales