
#include <cmath>
#include <optional>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

class EncoderSensor {
public:
    EncoderSensor(){};
    std::optional< double > read( const char* str );
};

std::optional< double > EncoderSensor::read( const char* str ) {
    for ( int i = 0; i < strlen( str ); i++ ) {
        if ( str[i] < '0' || str[i] > '9' ) {
            return std::nullopt;
        }
    }
    char*     end;
    long long data = strtoll( str, &end, 0 );

    double angle = ( double )( data ) / 16384.0 * 2 * M_PI;
    while ( angle <= -M_PI ) {
        angle += M_PI;
    }
    while ( angle >= M_PI ) {
        angle -= M_PI;
    }
    return angle;
}

int main( int argc, char* argv[] ) {
    if ( argc == 1 ) {
        printf( " usage example:\n   ./bin/sensor-read 3151\n" );
        return -1;
    }
    EncoderSensor           sensor;
    std::optional< double > angle = sensor.read( argv[1] );
    if ( angle == std::nullopt ) {
        printf( "sensor read error\n" );
        return 0;
    }
    printf( "sensor angle = %4.3f\n", angle.value() );
    return 0;
}
