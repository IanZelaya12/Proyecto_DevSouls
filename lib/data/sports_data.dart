import 'package:proyecto_devsouls/models/sports_venue.dart';

class SportsData {
  static List<SportsVenue> getAllVenues() {
    return [
      // Fútbol
      SportsVenue(
        id: 'futbol_1',
        name: 'Cancha de Fútbol Municipal',
        sport: 'Fútbol',
        location: 'Centro, Tegucigalpa',
        description:
            'Cancha de fútbol profesional con césped sintético de última generación. Ideal para partidos y entrenamientos con iluminación nocturna.',
        pricePerHour: 650.00,
        rating: 4.8,
        reviewCount: 142,
        imageUrl:
            'https://images.unsplash.com/photo-1489944440615-453fc2b6a9a9?w=400',
        facilities: [
          'Césped Sintético',
          'Iluminación',
          'Vestidores',
          'Parqueo',
          'Gradas',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1489944440615-453fc2b6a9a9?w=150',
          'https://images.unsplash.com/photo-1518604666860-9ed391f76460?w=150',
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=150',
        ],
      ),
      SportsVenue(
        id: 'futbol_2',
        name: 'Campo Deportivo Las Palmas',
        sport: 'Fútbol',
        location: 'Las Palmas, Tegucigalpa',
        description:
            'Amplio campo de fútbol con césped natural, perfecto para torneos y eventos deportivos.',
        pricePerHour: 750.00,
        rating: 4.6,
        reviewCount: 89,
        imageUrl:
            'https://images.unsplash.com/photo-1518604666860-9ed391f76460?w=400',
        facilities: [
          'Césped Natural',
          'Gradas',
          'Cafetería',
          'Parqueo',
          'Sonido',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1518604666860-9ed391f76460?w=150',
          'https://images.unsplash.com/photo-1489944440615-453fc2b6a9a9?w=150',
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=150',
        ],
      ),
      SportsVenue(
        id: 'futbol_3',
        name: 'Estadio Comunitario El Bosque',
        sport: 'Fútbol',
        location: 'El Bosque, Tegucigalpa',
        description:
            'Estadio comunitario renovado con todas las comodidades modernas.',
        pricePerHour: 850.00,
        rating: 4.9,
        reviewCount: 203,
        imageUrl:
            'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
        facilities: [
          'Certificado FIFA',
          'Vestidores VIP',
          'Transmisión',
          'Seguridad',
          'Restaurant',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=150',
          'https://images.unsplash.com/photo-1489944440615-453fc2b6a9a9?w=150',
          'https://images.unsplash.com/photo-1518604666860-9ed391f76460?w=150',
        ],
      ),

      // Basketball
      SportsVenue(
        id: 'basket_1',
        name: 'Cancha de Basketball Central',
        sport: 'Basketball',
        location: 'Anillo Periférico, Tegucigalpa',
        description:
            'Cancha de basketball techada con piso de duela profesional.',
        pricePerHour: 550.00,
        rating: 4.7,
        reviewCount: 98,
        imageUrl:
            'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
        facilities: [
          'Piso Duela',
          'Aire Acondicionado',
          'Gradas',
          'Marcador',
          'Vestidores',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=150',
          'https://images.unsplash.com/photo-1574623452334-1e0ac2b3ccb4?w=150',
          'https://images.unsplash.com/photo-1608245449230-4ac19066d2d0?w=150',
        ],
      ),
      SportsVenue(
        id: 'basket_2',
        name: 'Complejo Deportivo Kennedy',
        sport: 'Basketball',
        location: 'Kennedy, Tegucigalpa',
        description: 'Complejo deportivo con múltiples canchas de basketball.',
        pricePerHour: 480.00,
        rating: 4.5,
        reviewCount: 156,
        imageUrl:
            'https://images.unsplash.com/photo-1574623452334-1e0ac2b3ccb4?w=400',
        facilities: [
          '3 Canchas',
          'WiFi',
          'Cafetería',
          'Parqueo',
          'Tienda Deportiva',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1574623452334-1e0ac2b3ccb4?w=150',
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=150',
          'https://images.unsplash.com/photo-1608245449230-4ac19066d2d0?w=150',
        ],
      ),
      SportsVenue(
        id: 'basket_3',
        name: 'Arena Deportiva Metropolitana',
        sport: 'Basketball',
        location: 'Centro Metropolitano, Tegucigalpa',
        description: 'Arena moderna con capacidad para 2000 espectadores.',
        pricePerHour: 920.00,
        rating: 4.9,
        reviewCount: 267,
        imageUrl:
            'https://images.unsplash.com/photo-1608245449230-4ac19066d2d0?w=400',
        facilities: [
          'Arena Profesional',
          'Transmisión HD',
          'VIP Lounge',
          'Medical Center',
          'Press Room',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1608245449230-4ac19066d2d0?w=150',
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=150',
          'https://images.unsplash.com/photo-1574623452334-1e0ac2b3ccb4?w=150',
        ],
      ),

      // Natación
      SportsVenue(
        id: 'natacion_1',
        name: 'Piscina Olímpica Nacional',
        sport: 'Natación',
        location: 'Villa Olímpica, Tegucigalpa',
        description: 'Piscina olímpica de 50 metros con 8 carriles.',
        pricePerHour: 780.00,
        rating: 4.8,
        reviewCount: 234,
        imageUrl:
            'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=400',
        facilities: [
          '50m Olímpica',
          'Cronometraje Digital',
          'Gradas',
          'Vestidores',
          'Sauna',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=150',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150',
          'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=150',
        ],
      ),
      SportsVenue(
        id: 'natacion_2',
        name: 'Club Acuático Las Torres',
        sport: 'Natación',
        location: 'Las Torres, Tegucigalpa',
        description:
            'Club exclusivo con piscina semiolímpica y área recreativa.',
        pricePerHour: 650.00,
        rating: 4.6,
        reviewCount: 187,
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        facilities: [
          'Piscina 25m',
          'Clases',
          'Área Niños',
          'Restaurant',
          'Jacuzzi',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150',
          'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=150',
          'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=150',
        ],
      ),
      SportsVenue(
        id: 'natacion_3',
        name: 'Centro Acuático Moderno',
        sport: 'Natación',
        location: 'Moderna, Tegucigalpa',
        description:
            'Modernas instalaciones acuáticas con sistema de filtrado avanzado.',
        pricePerHour: 580.00,
        rating: 4.7,
        reviewCount: 145,
        imageUrl:
            'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=400',
        facilities: [
          'Filtrado UV',
          'Terapia Acuática',
          'Temperatura Controlada',
          'Accesibilidad',
          'Parking',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=150',
          'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=150',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150',
        ],
      ),

      // Yoga
      SportsVenue(
        id: 'yoga_1',
        name: 'Estudio Yoga Zen',
        sport: 'Yoga',
        location: 'Centro Zen, Tegucigalpa',
        description: 'Estudio especializado en yoga con ambiente relajante.',
        pricePerHour: 320.00,
        rating: 4.9,
        reviewCount: 298,
        imageUrl:
            'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
        facilities: [
          'Ambiente Zen',
          'Mat Incluido',
          'Música Relajante',
          'Aire Puro',
          'Té Gratis',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=150',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150',
        ],
      ),
      SportsVenue(
        id: 'yoga_2',
        name: 'Centro Bienestar Integral',
        sport: 'Yoga',
        location: 'Bienestar, Tegucigalpa',
        description:
            'Centro integral de bienestar con clases de yoga, meditación y relajación.',
        pricePerHour: 280.00,
        rating: 4.7,
        reviewCount: 245,
        imageUrl:
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
        facilities: [
          'Jardín Interior',
          'Meditación',
          'Aromaterapia',
          'Masajes',
          'Biblioteca',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150',
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=150',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150',
        ],
      ),
      SportsVenue(
        id: 'yoga_3',
        name: 'Yoga Studio Premium',
        sport: 'Yoga',
        location: 'Premium Zone, Tegucigalpa',
        description: 'Studio premium con tecnología de última generación.',
        pricePerHour: 450.00,
        rating: 4.8,
        reviewCount: 189,
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        facilities: [
          'Hot Yoga',
          'Aerial Yoga',
          'Personal Training',
          'Locker Premium',
          'Smoothie Bar',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150',
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=150',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150',
        ],
      ),

      // Voleibol
      SportsVenue(
        id: 'volei_1',
        name: 'Cancha de Voleibol Arena',
        sport: 'Voleibol',
        location: 'Arena Deportiva, Tegucigalpa',
        description: 'Cancha profesional de voleibol con piso especializado.',
        pricePerHour: 420.00,
        rating: 4.5,
        reviewCount: 123,
        imageUrl:
            'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=400',
        facilities: [
          'Piso Especializado',
          'Red Profesional',
          'Iluminación LED',
          'Gradas',
          'Vestidores',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=150',
          'https://images.unsplash.com/photo-1594736797933-d0301ba2fe65?w=150',
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=150',
        ],
      ),

      // Gimnasia
      SportsVenue(
        id: 'gimnasia_1',
        name: 'Gimnasio Olímpico Central',
        sport: 'Gimnasia',
        location: 'Centro Olímpico, Tegucigalpa',
        description:
            'Gimnasio especializado en gimnasia artística con equipos profesionales.',
        pricePerHour: 680.00,
        rating: 4.7,
        reviewCount: 156,
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        facilities: [
          'Equipos Profesionales',
          'Colchonetas',
          'Barras Asimétricas',
          'Trampolín',
          'Instructor',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150',
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=150',
        ],
      ),

      // Hip Hop
      SportsVenue(
        id: 'hiphop_1',
        name: 'Studio Hip Hop Urban',
        sport: 'Hip Hop',
        location: 'Urban District, Tegucigalpa',
        description: 'Studio especializado en hip hop y danzas urbanas.',
        pricePerHour: 380.00,
        rating: 4.8,
        reviewCount: 298,
        imageUrl:
            'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=400',
        facilities: [
          'Espejos Profesionales',
          'Sound System',
          'Piso Especializado',
          'AC',
          'Agua Gratis',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=150',
          'https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=150',
          'https://images.unsplash.com/photo-1520637836862-4d197d17c983?w=150',
        ],
      ),

      // Calistenia
      SportsVenue(
        id: 'calistenia_1',
        name: 'Parque Calistenia Outdoor',
        sport: 'Calistenia',
        location: 'Parque Central, Tegucigalpa',
        description:
            'Parque al aire libre con barras y equipos especializados para calistenia.',
        pricePerHour: 250.00,
        rating: 4.6,
        reviewCount: 178,
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        facilities: [
          'Barras Pull-up',
          'Paralelas',
          'Escalera Sueca',
          'Outdoor',
          'Comunidad',
        ],
        galleryImages: [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150',
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=150',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150',
        ],
      ),
    ];
  }

  static List<String> getSports() {
    return [
      'Fútbol',
      'Basketball',
      'Natación',
      'Voleibol',
      'Yoga',
      'Gimnasia',
      'Hip Hop',
      'Calistenia',
    ];
  }

  // Método helper para obtener deportes que coincidan con el filtro
  static List<SportsVenue> getVenuesBySport(String sport) {
    if (sport == 'Todos' || sport.isEmpty) {
      return getAllVenues();
    }
    return getAllVenues()
        .where((venue) => venue.sport.toLowerCase() == sport.toLowerCase())
        .toList();
  }
}
