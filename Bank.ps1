# Hasło do logowania (w rzeczywistym środowisku należy zastosować bezpieczniejsze rozwiązanie)
$password = "haslo123"

# Funkcja generowania losowego stanu konta
function Get-RandomAccountBalance {
    # Zwróć losową wartość liczbową zaokrągloną do dwóch miejsc po przecinku z zakresu od 1000 do 100000
    return [math]::Round((Get-Random -Minimum 1000 -Maximum 100000), 2)
}

# Inicjalizacja stanu konta
$global:accountBalance = Get-RandomAccountBalance

# Inicjalizacja historii transakcji
$global:transactionHistory = @()

# Funkcja logowania
function Login {
    param(
        [string]$inputPassword
    )

    if ($inputPassword -eq $password) {
        # Wyświetl komunikat o powodzeniu logowania
        Write-Host "Logowanie powiodło się!"
        return $true
    } else {
        # Wyświetl komunikat o niepoprawnym haśle
        Write-Host "Niepoprawne hasło!"
        return $false
    }
}

# Funkcja pobierania stanu konta
function Get-AccountBalance {
    # Wyświetl aktualny stan konta
    Write-Host "Aktualny stan konta: $($global:accountBalance)"
}

# Funkcja generowania losowej transakcji
function Get-RandomTransaction {
    # Wybierz losowy typ transakcji (wpłata lub wypłata)
    $transactionTypes = @("Wpłata", "Wypłata")
    $randomTransactionType = $transactionTypes | Get-Random

    # Wygeneruj losową kwotę transakcji z zakresu od 10 do 1000
    $transactionAmount = [math]::Round((Get-Random -Minimum 10 -Maximum 1000), 2)

    # Zmień wartość kwoty transakcji na ujemną, jeśli jest to wypłata
    if ($randomTransactionType -eq "Wypłata") {
        $transactionAmount = $transactionAmount * -1
    }

    # Zwróć tablicę skrótów, opisującą transakcję
    return @{
        Data = Get-Date
        Typ = $randomTransactionType
        Kwota = $transactionAmount
    }
}

# Funkcja generowania losowej historii transakcji
function Generate-RandomTransactionHistory {
    $transactionHistory = @()

    # Wygeneruj losową historię transakcji zawierającą od 10 do 50 transakcji
    for ($i = 0; $i -lt (Get-Random -Minimum 10 -Maximum 50); $i++) {
        $transactionHistory += Get-RandomTransaction
    }

    # Zwróć wygenerowaną historię transakcji
    return $transactionHistory
}

# Funkcja wyświetlania historii transakcji
function Show-TransactionHistory {
    if ($global:transactionHistory.Count -eq 0) {
        # Wygeneruj losową historię transakcji, jeśli jeszcze nie istnieje
        $global:transactionHistory = Generate-RandomTransactionHistory
    }

    # Wyświetl historię transakcji w formie tabeli
    Write-Host "Historia transakcji:"
    $global:transactionHistory | Format-Table -AutoSize
}

# Funkcja dodawania transakcji do historii
function Add-TransactionToHistory {
    param (
        [decimal]$amount,
        [string]$transactionType
    )

    # Utwórz tablicę skrótów opisującą transakcję
    $transaction = @{
        Data = Get-Date
        Typ = $transactionType
        Kwota = $amount
    }

    # Dodaj transakcję do historii
    $global:transactionHistory += $transaction
}

# Funkcja wpłaty środków na konto
function Deposit {
    param(
        [decimal]$amount
    )

    # Zwiększ stan konta o kwotę wpłaty
    $global:accountBalance += $amount

    # Wyświetl aktualny stan konta i kwotę wpłaty
    Write-Host "Aktualny stan konta: $($global:accountBalance)"
    Write-Host "Kwota wpłaty: $($amount)"

    # Dodaj wpłatę do historii
    Add-TransactionToHistory -amount $amount -transactionType "Wpłata"
}

# Funkcja wypłaty środków z konta
function Withdraw {
    param(
        [decimal]$amount
    )

    # Sprawdź, czy istnieją wystarczające środki na koncie
    if ($amount -le $global:accountBalance) {
        # Odejmij kwotę wypłaty od stanu konta
        $global:accountBalance -= $amount

        # Wyświetl aktualny stan konta i kwotę wypłaty
        Write-Host "Aktualny stan konta: $($global:accountBalance)"
        Write-Host "Kwota wypłaty: $($amount)"

        # Dodaj wypłatę do historii
        Add-TransactionToHistory -amount $amount -transactionType "Wypłata"
    } else {
        # Wyświetl komunikat o braku wystarczających środków
        Write-Host "Nie masz wystarczających środków na koncie!"
    }
}

# Główny pętla programu
do {
    # Poproś użytkownika o podanie hasła do logowania
    $passwordInput = Read-Host "Podaj hasło"

    # Sprawdź poprawność hasła
    $loggedIn = Login -inputPassword $passwordInput

    # Jeśli logowanie powiodło się
    if ($loggedIn) {
        # Wyświetl stan konta przy uruchomieniu
        Get-AccountBalance

        # Inicjalizacja zmiennej opcji
        $option = ""

        # Rozpocznij pętlę wyboru opcji
        do {
            # Wyświetl dostępne opcje dla użytkownika
            Write-Host "Wybierz opcję:"
            Write-Host "1. Historia transakcji"
            Write-Host "2. Wpłata"
            Write-Host "3. Wypłata"
            Write-Host "4. Wyloguj"
            Write-Host "5. Pokaz stan konta"

            # Odczytaj wybór użytkownika
            $option = Read-Host "Twoja opcja"

            # Wykonaj akcję zgodnie z wyborem użytkownika
            switch ($option) {
                1 { Show-TransactionHistory }  # Wyświetl historię transakcji
                2 { Deposit -amount (Read-Host "Podaj kwotę wpłaty") }  # Wykonaj wpłatę
                3 { Withdraw -amount (Read-Host "Podaj kwotę wypłaty") }  # Wykonaj wypłatę
                4 { Write-Host "Wylogowano"; break }  # Wyloguj użytkownika
                5 { Get-AccountBalance }  # Wyświetl stan konta
                default { Write-Host "Niepoprawna opcja!" }
            }
        } while ($option -ne "4")
    }
} while ($loggedIn -eq $false)
