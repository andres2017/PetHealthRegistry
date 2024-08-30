// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PetHealthRegistry {
    struct HealthRecord {
        string description;  // Descripción del registro de salud
        uint256 date;        // Fecha del registro en segundos desde el epoch
        address vet;         // Dirección del veterinario
    }

    struct Pet {
        string name;         // Nombre de la mascota
        uint256 age;         // Edad de la mascota
        address owner;       // Dirección del propietario
        bool isLost;         // Indica si la mascota está perdida
    }

    // Mappings
    mapping(address => Pet) public pets;  // Información de las mascotas por dirección del propietario
    mapping(address => HealthRecord[]) public petHealthRecords;  // Registros de salud por dirección de propietario

    // Eventos
    event PetRegistered(address indexed owner, string name, uint256 age);
    event HealthRecordAdded(address indexed petOwner, string description, uint256 date, address vet);
    event PetReportedLost(address indexed petOwner, bool isLost);

    // Función para registrar una nueva mascota
    function registerPet(string memory _name, uint256 _age) public {
        require(bytes(_name).length > 0, "El nombre de la mascota es obligatorio.");
        require(_age > 0, "La edad debe ser mayor que cero.");

        pets[msg.sender] = Pet({
            name: _name,
            age: _age,
            owner: msg.sender,
            isLost: false
        });

        emit PetRegistered(msg.sender, _name, _age);
    }

    // Función para agregar un registro de salud
    function addHealthRecord(string memory _description, uint256 _date) public {
        require(pets[msg.sender].owner == msg.sender, "Solo el propietario de la mascota puede agregar registros de salud.");

        petHealthRecords[msg.sender].push(HealthRecord({
            description: _description,
            date: _date,
            vet: msg.sender  // Usar msg.sender como vet
        }));

        emit HealthRecordAdded(msg.sender, _description, _date, msg.sender);
    }

    // Función para obtener los registros de salud de una mascota
    function getHealthRecords() public view returns (HealthRecord[] memory) {
        return petHealthRecords[msg.sender];
    }

    // Función para marcar una mascota como perdida
    function reportLost(bool _isLost) public {
        require(pets[msg.sender].owner == msg.sender, "Solo el propietario de la mascota puede reportar a la mascota como perdida.");

        pets[msg.sender].isLost = _isLost;

        emit PetReportedLost(msg.sender, _isLost);
    }

    // Función para obtener la información de una mascota
    function getPetInfo() public view returns (string memory name, uint256 age, bool isLost) {
        Pet memory pet = pets[msg.sender];
        return (pet.name, pet.age, pet.isLost);
    }
}
