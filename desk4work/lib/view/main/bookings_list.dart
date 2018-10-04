import 'package:cached_network_image/cached_network_image.dart';
import 'package:desk4work/model/booking.dart';
import 'package:desk4work/utils/string_resources.dart';
import 'package:desk4work/view/common/box_decoration_util.dart';
import 'package:flutter/material.dart';

class BookingsListScreen extends StatefulWidget {
  final List<Booking> _bookings;

  BookingsListScreen(this._bookings);

  @override
  State<StatefulWidget> createState() => _BookingsListState();
}

class _BookingsListState extends State<BookingsListScreen> {
  List<Booking> _bookings;
  Size _screenSize;
  double _screenHeight, _screenWidth;
  StringResources _stringResources;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
    _stringResources = StringResources.of(context);
    _bookings = widget._bookings; //TODO change it to the global model
    _bookings = [];
    for(int i=0; i<10; i++){
      _bookings.add(Booking(id: i));
    }
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: _screenWidth * .293, vertical: _screenHeight * .0225),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _bookings.length,
          itemBuilder: (ctx, index) {
            _getBookingCard(_bookings[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newBooking,
        child: Container(
          decoration: BoxDecorationUtil.getOrangeGradient(),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _getBookingCard(Booking booking) {
    return Card(
      margin: EdgeInsets.all(.0),
      child: Container(
        height: _screenHeight * .1409,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: booking.id,
              child: Image.asset(
                'assets/placeholder.png',
                width: _screenWidth * .2773,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _screenWidth * .0386,
                  vertical: _screenHeight * .0179),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Клевер коворкинг",
                  ),
                  Text(
                    "24 июля 2017",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  _getLowerCardPart("00:00"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getLowerCardPart(String remainingTime) {
    bool isTimeUp = (remainingTime.substring(0, 2) == '00' &&
        remainingTime.substring(2) == '00');
    Color color = isTimeUp ? Colors.red : Colors.black;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: color,
            ),
            Text(
              remainingTime,
              style: Theme.of(context).textTheme.body1.copyWith(color: color),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: isTimeUp ? _extendBooking(1) : _endBooking(1),
              child: Text(
                isTimeUp ? _stringResources.tExtend : _stringResources.tTerminate,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.orange),
              ),
            )
          ],
        )
      ],
    );
  }

  _newBooking() {}

  _endBooking(int id) {}

  _extendBooking(int id) {}

  _openBooking(Booking booking) {}
}
