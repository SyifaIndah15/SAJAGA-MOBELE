import 'package:flutter/material.dart';
import '../../config/app_constant.dart';


class ScheduleCard extends StatelessWidget {


final String name;
final String time;
final String status;


const ScheduleCard({

super.key,

required this.name,

required this.time,

required this.status,

});



@override
Widget build(BuildContext context){


return Container(

margin:
const EdgeInsets.only(bottom:12),


padding:
const EdgeInsets.all(15),


decoration:

BoxDecoration(

color:
Colors.white,


borderRadius:
BorderRadius.circular(16),


boxShadow:[

BoxShadow(

color:
Colors.black12,

blurRadius:8,

offset:
const Offset(0,3)

)

]


),


child:

Row(

children:[



Container(

height:45,

width:45,


decoration:

BoxDecoration(

color:
AppColors.lightBlue,

borderRadius:
BorderRadius.circular(12)

),


child:

const Icon(

Icons.medication,

color:
AppColors.primary,

),

),



const SizedBox(width:15),




Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[


Text(

name,

style:

const TextStyle(

fontWeight:
FontWeight.bold,

fontSize:15

),

),



Text(

time,

style:

const TextStyle(

color:
AppColors.grey,

fontSize:12

),

),



Text(

status,

style:

const TextStyle(

color:
Colors.orange,

fontSize:12

),

)



]


)

]

)


);


}

}