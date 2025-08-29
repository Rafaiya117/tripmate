import 'package:flutter/material.dart';
import 'package:trip_mate/features/history/models/history_details_model.dart';

class HistoryDetailsController extends ChangeNotifier {
  HistoryDetailsModel? _historyDetails;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  HistoryDetailsModel? get historyDetails => _historyDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load history details by ID
  Future<void> loadHistoryDetails(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock data based on ID
      _historyDetails = _getMockHistoryDetails(id);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load history details';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mock data generator
  HistoryDetailsModel _getMockHistoryDetails(String id) {
    switch (id) {
      case '1':
        return HistoryDetailsModel(
          id: '1',
          title: 'Lalbag kella',
          imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&h=400&fit=crop',
          location: 'Old Dhaka, Bangladesh',
          year: '1678',
          description: 'Lalbagh Fort\'s construction began in **1678** by **Prince Muhammad Azam Shah**, but it was left incomplete due to his departure from Dhaka. His successor, **Nawab Shaista Khan**, did not continue the work, and the fort remains unfinished to this day.',
          construction: 'Began in **1678** by **Mughal Prince Muhammad Azam** (son of **Emperor Aurangzeb**).',
          unfinishedStructure: 'The fort was never completed. Later, **Subahdar Shaista Khan** continued construction but left it unfinished.',
          visitingHours: '**Tuesday–Saturday**: 10:00 AM – 5:00 PM\n**Monday**: 2:00 PM – 6:00 PM\n**Friday**: 10:00 AM – 1:00 PM, then 1:30 PM – 5:00 PM\nClosed on Sundays & public holidays',
          additionalInfo: '**However**, his tenure in Bengal was short. In **1679**, he was summoned back to **Delhi**, leaving the fort unfinished. The responsibility then passed to **Shaista Khan**, another prominent Mughal governor of Bengal.',
        );
      
      case '2':
        return HistoryDetailsModel(
          id: '2',
          title: 'India Gate',
          imageUrl: 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800&h=400&fit=crop',
          location: 'New Delhi, India',
          year: '1931',
          description: 'India Gate is a war memorial located in New Delhi, India. It was designed by **Sir Edwin Lutyens** and commemorates the **82,000 soldiers** of the British Indian Army who died in the period 1914–1921.',
          construction: 'Built in **1931** by **Sir Edwin Lutyens** as a memorial to British Indian Army soldiers.',
          unfinishedStructure: 'The structure was completed as designed and stands as a symbol of sacrifice and valor.',
          visitingHours: '**Open 24/7** for public viewing\n**Best time to visit**: Evening (6:00 PM – 9:00 PM)\n**Light show**: 7:00 PM – 9:00 PM daily',
          additionalInfo: 'The **Amar Jawan Jyoti** (Flame of the Immortal Soldier) was added in **1971** to commemorate Indian soldiers who died in the Indo-Pakistan War.',
        );
      
      case '3':
        return HistoryDetailsModel(
          id: '3',
          title: 'Stonehenge',
          imageUrl: 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800&h=400&fit=crop',
          location: 'Wiltshire, England',
          year: '3000 BC',
          description: 'Stonehenge is a prehistoric monument consisting of a ring of standing stones, each around **13 feet high**, **7 feet wide**, and weighing around **25 tons**.',
          construction: 'Built between **3000 BC** and **2000 BC** by Neolithic and Bronze Age people.',
          unfinishedStructure: 'The monument evolved over time with multiple construction phases spanning 1500 years.',
          visitingHours: '**March 15 – May 31**: 9:30 AM – 7:00 PM\n**June 1 – August 31**: 9:00 AM – 8:00 PM\n**September 1 – October 15**: 9:30 AM – 7:00 PM\n**October 16 – March 14**: 9:30 AM – 5:00 PM',
          additionalInfo: 'The stones are arranged in a circle with the largest stones, known as **sarsens**, weighing up to **30 tons** each.',
        );
      
      case '4':
        return HistoryDetailsModel(
          id: '4',
          title: 'Mount Rushmore',
          imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&h=400&fit=crop',
          location: 'South Dakota, USA',
          year: '1927',
          description: 'Mount Rushmore National Memorial features **60-foot sculptures** of the heads of four United States presidents: **George Washington**, **Thomas Jefferson**, **Theodore Roosevelt**, and **Abraham Lincoln**.',
          construction: 'Carved between **1927** and **1941** by **Gutzon Borglum** and his son **Lincoln Borglum**.',
          unfinishedStructure: 'The original design included full-body sculptures, but only the heads were completed due to funding constraints.',
          visitingHours: '**May 27 – August 11**: 5:00 AM – 11:00 PM\n**August 12 – September 30**: 5:00 AM – 10:00 PM\n**October 1 – May 26**: 5:00 AM – 9:00 PM\n**Parking**: 5:00 AM – 11:00 PM',
          additionalInfo: 'The project cost **\$989,992.32** and employed **400 workers** over 14 years of construction.',
        );
      
      case '5':
        return HistoryDetailsModel(
          id: '5',
          title: 'Eiffel Tower',
          imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop',
          location: 'Paris, France',
          year: '1889',
          description: 'The Eiffel Tower is a wrought-iron lattice tower located on the **Champ de Mars** in Paris, France. It was named after engineer **Gustave Eiffel**, whose company designed and built the tower.',
          construction: 'Built from **1887** to **1889** by **Gustave Eiffel** and his team of engineers.',
          unfinishedStructure: 'The tower was completed as designed and has become an iconic symbol of Paris.',
          visitingHours: '**June 15 – September 1**: 9:00 AM – 12:45 AM\n**September 2 – June 14**: 9:30 AM – 11:45 PM\n**Last entry**: 45 minutes before closing\n**Elevator hours**: Same as tower hours',
          additionalInfo: 'The tower stands **324 meters (1,063 feet)** tall and was the tallest man-made structure in the world until **1930**.',
        );
      
      case '6':
        return HistoryDetailsModel(
          id: '6',
          title: 'Colosseum',
          imageUrl: 'https://images.unsplash.com/photo-1555992336-03a23c7b20ee?w=800&h=400&fit=crop',
          location: 'Rome, Italy',
          year: '80 AD',
          description: 'The Colosseum is an ancient amphitheater built of concrete and stone. It is the largest ancient amphitheater ever built and is considered one of the greatest works of **Roman architecture** and engineering.',
          construction: 'Built between **70-80 AD** under the emperors **Vespasian** and **Titus** of the **Flavian dynasty**.',
          unfinishedStructure: 'The Colosseum was completed as designed and could hold **50,000-80,000 spectators**.',
          visitingHours: '**March 1 – August 31**: 8:30 AM – 7:00 PM\n**September 1 – September 30**: 8:30 AM – 7:00 PM\n**October 1 – October 26**: 8:30 AM – 6:30 PM\n**October 27 – February 28**: 8:30 AM – 4:30 PM',
          additionalInfo: 'The Colosseum was used for **gladiatorial contests**, **public spectacles**, **animal hunts**, and **dramatic performances** based on Classical mythology.',
        );
      
      default:
        return HistoryDetailsModel(
          id: id,
          title: 'Historical Landmark',
          imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&h=400&fit=crop',
          location: 'Unknown Location',
          year: 'Unknown',
          description: 'This is a historical landmark with rich cultural significance.',
          construction: 'Construction details are not available.',
          unfinishedStructure: 'Information about the structure is limited.',
          visitingHours: 'Visiting hours are not specified.',
          additionalInfo: 'Additional information is not available.',
        );
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset state
  void reset() {
    _historyDetails = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
