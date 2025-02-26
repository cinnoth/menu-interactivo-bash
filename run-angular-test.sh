#!/bin/bash

# Configuración de rutas
PROJECT_PATH="/angular-selenium-docker/proyecto-angular-selenium"
SELENIUM_TESTS_PATH="$PROJECT_PATH/tests"

# Función para iniciar Angular
iniciar_angular() {
    echo "Iniciando el proyecto de Angular..."
    cd "$PROJECT_PATH" || { echo "Error: No se encontró la carpeta del proyecto"; exit 1; }

    # Ejecutar Angular en segundo plano y guardar el PID
    ng serve --host 0.0.0.0 --port 4200 > angular.log 2>&1 &
    ANGULAR_PID=$!
    echo "Angular levantado con PID $ANGULAR_PID"

    # Capturar señal para detener Angular al salir
    trap 'kill $ANGULAR_PID' EXIT

    # Esperar a que Angular esté disponible
    echo "Esperando a que Angular se levante..."
    while ! curl -s http://localhost:4200 > /dev/null; do
        sleep 2
    done

    echo "Angular está corriendo en http://localhost:4200"
}

# Función para ejecutar pruebas de Selenium
ejecutar_selenium() {
    echo "Ejecutando pruebas de Selenium..."
    cd "$SELENIUM_TESTS_PATH" || { echo "Error: No se encontró la carpeta de pruebas Selenium"; exit 1; }
    
    # Ejecutar prueba
    node title-test.js
    echo "Pruebas Selenium finalizadas."
}

# Función para ejecutar pruebas con Cucumber
ejecutar_cucumber() {
    echo "Ejecutando pruebas con Cucumber..."
    cd "$PROJECT_PATH" || { echo "Error: No se encontró la carpeta del proyecto"; exit 1; }

    # Ejecutar pruebas con Cucumber
    npx cucumber-js
    echo "Pruebas Cucumber finalizadas."
}

# Función para mostrar el menú interactivo
mostrar_menu() {
    while true; do
        echo ""
        echo "*****  MENÚ INTERACTIVO *****"
        echo "1. Iniciar aplicación Angular"
        echo "2. Ejecutar pruebas de Selenium"
        echo "3. Ejecutar pruebas con Cucumber"
        echo "4. Salir"
        echo "*******************************"
        read -p "Selecciona una opción: " opcion
	echo "*******************************"
        case $opcion in
            1) iniciar_angular ;;
            2) ejecutar_selenium ;;
            3) ejecutar_cucumber ;;
            4) echo "Saliendo..."; exit 0 ;;
            *) echo "Opción no válida. Intenta de nuevo." ;;
        esac
    done
}

mostrar_menu
