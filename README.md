## Pruebas en Cucumber y Selenium 

1. Abrir proyecto-angular-selenium
2. Instalar Cucumber y Selenium con el comando 

    ```
    npm install --save-dev @cucumber/cucumber selenium-webdriver chai
    ```
3. Crear las carpetas necesarias para la prueba cucumber

✨  Toma en cuenta que la estructura Angular se organizará de la siguiente manera:

```
/proyecto-pruebas
│── package.json
│── cucumber.js
│── features/
│   ├── cucumber_prueba.feature
│── step_definitions/
│   ├── cucumber_prueba.steps.js
```

1. Configurar cucumber.js. Crea un archivo llamado cucumber.js en la raíz del proyecto con este contenido:

    ```
    module.exports = {
    default: {
    require: ["./step_definitions/*.js"], // Ruta de los step definitions
    format: ["progress", "json:results.json"], // Formato de salida
    paths: ["./features/*.feature"], // Ruta de los archivos feature
    },
    };
    ```
2. Escribir la Prueba en cucumber_prueba.feature. Crea una carpeta features/ y dentro el archivo cucumber_prueba.feature con el siguiente contenido:
    ```
    Feature: Abrir aplicación angular y hacer clic en un enlace del menu
    Scenario: Usuario abre la app y hace clic en 'Learn with Tutorials'
        Given el usuario abre la página Angular
        When el usuario hace clic en 'Learn with Tutorials'
        Then el usuario es redirigido a la página de tutoriales
    ```
3. Crear los Steps en cucumber_prueba.steps.js. Crea una carpeta step_definitions/ y dentro el archivo mi_prueba.steps.js con el siguiente código:
    ```
    const { Given, When, Then, After } = require("@cucumber/cucumber");
    const { Builder, By, until } = require("selenium-webdriver");
    const chrome = require("selenium-webdriver/chrome");
    const assert = require("assert").strict;

    let driver;

    Given("el usuario abre la página Angular", async function () {
    const options = new chrome.Options();
    const uniqueUserDir = `/tmp/chrome-profile-${Date.now()}`;
    options.addArguments(`--user-data-dir=${uniqueUserDir}`);

    options.addArguments('--headless'); 
    options.addArguments('--disable-gpu');
    options.addArguments('--no-sandbox');
    options.addArguments('--disable-dev-shm-usage');


    driver = await new Builder().forBrowser("chrome").setChromeOptions(options).build();
    await driver.get("http://localhost:4200");
        });

    When("el usuario hace clic en 'Learn with Tutorials'", async function () {
    const link = await driver.wait(
        until.elementLocated(By.linkText("Learn with Tutorials")),
        5000
    );
    await link.click();
    });

    Then("el usuario es redirigido a la página de tutoriales", async function () {
    await driver.wait(until.urlContains("/tutorials"), 15000);
    const url = await driver.getCurrentUrl();
    assert.ok(url.includes("/tutorials"), "No se redirigió correctamente");
    });

    After(async function () {
    if (driver) {
        await driver.quit();
    }
    });
    ```
4. Ejecutar la Prueba. Para correr la prueba, usa este comando:
    ```
    npx cucumber-js
    ```
## CREA UN SCRIPT para ejecutar un menu de opciones.


1. En la carpeta realizada anteriormente de nombre "angular-selenium-docker" crea un script llamado run-angular-test usando nano.
    ```
    #!/bin/bash

    # Configuraci  n de rutas
    PROJECT_PATH="/angular-selenium-docker/proyecto-angular-selenium"
    SELENIUM_TESTS_PATH="$PROJECT_PATH/tests"

    # Funci  n para iniciar Angular
    iniciar_angular() {
        echo "Iniciando el proyecto de Angular..."
        cd "$PROJECT_PATH" || { echo "Error: No se encontr   la carpeta del proyecto"; exit 1; }

        # Ejecutar Angular en segundo plano y guardar el PID
        ng serve --host 0.0.0.0 --port 4200 > angular.log 2>&1 &
        ANGULAR_PID=$!
        echo "Angular levantado con PID $ANGULAR_PID"

        # Capturar se  al para detener Angular al salir
        trap 'kill $ANGULAR_PID' EXIT

        # Esperar a que Angular est   disponible
        echo "Esperando a que Angular se levante..."
        while ! curl -s http://localhost:4200 > /dev/null; do
            sleep 2
        done

        echo "Angular est   corriendo en http://localhost:4200"
    }
    # Funci  n para ejecutar pruebas de Selenium
    ejecutar_selenium() {
        echo "Ejecutando pruebas de Selenium..."
        cd "$SELENIUM_TESTS_PATH" || { echo "Error: No se encontr   la carpeta de pruebas Selenium"; exit 1; }
        
        # Ejecutar prueba
        node title-test.js
        echo "Pruebas Selenium finalizadas."
    }

    # Funci  n para ejecutar pruebas con Cucumber
    ejecutar_cucumber() {
        echo "Ejecutando pruebas con Cucumber..."
        cd "$PROJECT_PATH" || { echo "Error: No se encontr   la carpeta del proyecto"; exit 1; }

        # Ejecutar pruebas con Cucumber
        npx cucumber-js
        echo "Pruebas Cucumber finalizadas."
    }

    # Funci  n para mostrar el men   interactivo
    mostrar_menu() {
        while true; do
            echo ""
            echo "==== MEN ^z INTERACTIVO ===="
            echo "1. Iniciar aplicaci  n Angular"
            echo "2. Ejecutar pruebas de Selenium"
            echo "3. Ejecutar pruebas con Cucumber"
            echo "4. Salir"
            echo "=========================="
            read -p "Selecciona una opci  n: " opcion

            case $opcion in
                1) iniciar_angular ;;
                2) ejecutar_selenium ;;
                3) ejecutar_cucumber ;;
                4) echo "Saliendo..."; exit 0 ;;
                *) echo "Opci  n no v  lida. Intenta de nuevo." ;;
            esac
        done
    }

    mostrar_menu
    ```
2. **Ejecutar el menú**
    - Dar permisos de ejecución Para poder ejecutar el script, debes darle permisos de ejecución. Ejecuta el siguiente comando en la terminal:
        
        ```
      chmod +x run-angular-test.sh
        ```

    - Ejecutar el script Para ejecutar el script, simplemente escribe el siguiente comando en la terminal:

        ```
      ./run-angular-test.sh
        ```