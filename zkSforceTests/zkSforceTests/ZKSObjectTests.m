// Copyright (c) 2014 Simon Fell
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ZKSObjectTests.h"
#import "zkSObject.h"
#import "zkParser.h"
#import "ZKAddress.h"

@implementation ZKSObjectTests

-(ZKSObject *)parseSobject:(NSString *)sobjectContents {
    NSString *xml = [NSString stringWithFormat:@"<sObject xmlns:x='http://www.w3.org/2001/XMLSchema-instance'>%@</sObject>", sobjectContents];
    zkElement *e = [zkParser parseData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    return [[[ZKSObject alloc] initWithXmlElement:e] autorelease];
}

-(void)testLocation {
    NSString *xml = @"<type>Account</type><Id>001_test</Id><foo x:type='ens:location'><latitude>10</latitude><longitude>33</longitude></foo>";
    ZKSObject *so = [self parseSobject:xml];
    XCTAssertEqualObjects([so type], @"Account", @"type should match");
    XCTAssertEqualObjects([so id], @"001_test", @"Id wrong");
    ZKLocation*l = [so locationValue:@"foo"];
    XCTAssertNotNil(l, @"should have a location object");
    XCTAssertEqualObjects([ZKLocation class], [l class], @"location unexpected type");
    XCTAssertEqual(10.0, [l latitude], @"lattitude wrong");
    XCTAssertEqual(33.0, [l longitude], @"longitude wrong");
}

-(void)testAddress {
    NSString *xml = @"<type>Account</type><Id>001_test</Id><foo x:type='ens:address'><latitude>10</latitude><longitude>33</longitude><city>SF</city><country>USA</country><countryCode>US</countryCode><postalCode>94105</postalCode><state>Cali</state><stateCode>CA</stateCode><street>Market St</street></foo>";
    ZKSObject *so = [self parseSobject:xml];
    XCTAssertEqualObjects([so type], @"Account", @"type should match");
    XCTAssertEqualObjects([so id], @"001_test", @"Id wrong");
    ZKAddress*a = [so addressValue:@"foo"];
    XCTAssertNotNil(a, @"should have an address object");
    XCTAssertEqualObjects([ZKAddress class], [a class], @"address unexpected type");
    XCTAssertEqual(10.0, [a latitude], @"lattitude wrong");
    XCTAssertEqual(33.0, [a longitude], @"longitude wrong");
    XCTAssertEqualObjects([a city], @"SF", @"city wrong");
    XCTAssertEqualObjects([a country], @"USA", @"country wrong");
    XCTAssertEqualObjects([a countryCode], @"US", @"countryCode wrong");
    XCTAssertEqualObjects([a postalCode], @"94105", @"postalCode wrong");
    XCTAssertEqualObjects([a state], @"Cali", @"state wrong");
    XCTAssertEqualObjects([a stateCode], @"CA", @"stateCode wrong");
    XCTAssertEqualObjects([a street], @"Market St", @"street wrong");
}

@end
