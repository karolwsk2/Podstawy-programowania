class Ksiazka {
    [string]$Tytul
    [string]$Autor
    [string]$ISBN
    [bool]$Wypozyczona

    Ksiazka([string]$tytul, [string]$autor, [string]$isbn) {
        $this.Tytul = $tytul
        $this.Autor = $autor
        $this.ISBN = $isbn
        $this.Wypozyczona = $false
    }

    [void]Wypozycz() {
        $this.Wypozyczona = $true
    }

    [void]Zwroc() {
        $this.Wypozyczona = $false
    }

    [string]ToString() {
        return "$($this.Tytul) by $($this.Autor), ISBN: $($this.ISBN)"
    }
}

$biblioteka = @()

function DodajKsiazke($tytul, $autor, $isbn) {
    $ksiazka = [Ksiazka]::new($tytul, $autor, $isbn)
    $biblioteka += $ksiazka
    Write-Host "Dodano książkę: $($ksiazka.ToString())"
}

function DodajLosowaKsiazke($tytul, $autor) {
    $losowyISBN = Get-Random -Minimum 100000000 -Maximum 999999999
    DodajKsiazke $tytul $autor $losowyISBN
}

function WypozyczKsiazke($isbn) {
    $ksiazka = $biblioteka | Where-Object { $_.ISBN -eq $isbn -and $_.Wypozyczona -eq $false }
    if ($ksiazka -ne $null) {
        $ksiazka.Wypozycz()
        Write-Host "Wypożyczono książkę: $($ksiazka.ToString())"
    } else {
        Write-Host "Książka jest już wypożyczona lub nie istnieje."
    }
}

function ZwrocKsiazke($isbn) {
    $ksiazka = $biblioteka | Where-Object { $_.ISBN -eq $isbn -and $_.Wypozyczona -eq $true }
    if ($ksiazka -ne $null) {
        $ksiazka.Zwroc()
        Write-Host "Zwrócono książkę: $($ksiazka.ToString())"
    } else {
        Write-Host "Nie można zwrócić książki, która nie była wypożyczona."
    }
}

function WyswietlDostepneKsiazki() {
    Write-Host "Dostępne książki:"
    $dostepneKsiazki = $biblioteka | Where-Object { $_.Wypozyczona -eq $false }
    $dostepneKsiazki | ForEach-Object { Write-Host $_.ToString() }
}

# Przykładowe użycie
DodajLosowaKsiazke "Harry Potter" "J.K. Rowling"
DodajLosowaKsiazke "Władca Pierścieni" "J.R.R. Tolkien"

WyswietlDostepneKsiazki

# Wypożyczanie i zwracanie przy użyciu ISBN wygenerowanego losowo (musisz znać wartość ISBN)
# WypozyczKsiazke "123456789"
# ZwrocKsiazke "123456789"
