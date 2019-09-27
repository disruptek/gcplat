
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Proximity Beacon
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Registers, manages, indexes, and searches beacons.
## 
## https://developers.google.com/beacons/proximity/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "proximitybeacon"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProximitybeaconBeaconinfoGetforobserved_593677 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconinfoGetforobserved_593679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconinfoGetforobserved_593678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("fields")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "fields", valid_593792
  var valid_593793 = query.getOrDefault("quotaUser")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "quotaUser", valid_593793
  var valid_593807 = query.getOrDefault("alt")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = newJString("json"))
  if valid_593807 != nil:
    section.add "alt", valid_593807
  var valid_593808 = query.getOrDefault("oauth_token")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "oauth_token", valid_593808
  var valid_593809 = query.getOrDefault("callback")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "callback", valid_593809
  var valid_593810 = query.getOrDefault("access_token")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "access_token", valid_593810
  var valid_593811 = query.getOrDefault("uploadType")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "uploadType", valid_593811
  var valid_593812 = query.getOrDefault("key")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "key", valid_593812
  var valid_593813 = query.getOrDefault("$.xgafv")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = newJString("1"))
  if valid_593813 != nil:
    section.add "$.xgafv", valid_593813
  var valid_593814 = query.getOrDefault("prettyPrint")
  valid_593814 = validateParameter(valid_593814, JBool, required = false,
                                 default = newJBool(true))
  if valid_593814 != nil:
    section.add "prettyPrint", valid_593814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593838: Call_ProximitybeaconBeaconinfoGetforobserved_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
  ## 
  let valid = call_593838.validator(path, query, header, formData, body)
  let scheme = call_593838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593838.url(scheme.get, call_593838.host, call_593838.base,
                         call_593838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593838, url, valid)

proc call*(call_593909: Call_ProximitybeaconBeaconinfoGetforobserved_593677;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconinfoGetforobserved
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593910 = newJObject()
  var body_593912 = newJObject()
  add(query_593910, "upload_protocol", newJString(uploadProtocol))
  add(query_593910, "fields", newJString(fields))
  add(query_593910, "quotaUser", newJString(quotaUser))
  add(query_593910, "alt", newJString(alt))
  add(query_593910, "oauth_token", newJString(oauthToken))
  add(query_593910, "callback", newJString(callback))
  add(query_593910, "access_token", newJString(accessToken))
  add(query_593910, "uploadType", newJString(uploadType))
  add(query_593910, "key", newJString(key))
  add(query_593910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593912 = body
  add(query_593910, "prettyPrint", newJBool(prettyPrint))
  result = call_593909.call(nil, query_593910, nil, nil, body_593912)

var proximitybeaconBeaconinfoGetforobserved* = Call_ProximitybeaconBeaconinfoGetforobserved_593677(
    name: "proximitybeaconBeaconinfoGetforobserved", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/beaconinfo:getforobserved",
    validator: validate_ProximitybeaconBeaconinfoGetforobserved_593678, base: "/",
    url: url_ProximitybeaconBeaconinfoGetforobserved_593679,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsList_593951 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsList_593953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconsList_593952(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token obtained from a previous request to list beacons.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   q: JString
  ##    : Filter query string that supports the following field filters:
  ## 
  ## * **description:`"<string>"`**
  ##   For example: **description:"Room 3"**
  ##   Returns beacons whose description matches tokens in the string "Room 3"
  ##   (not necessarily that exact string).
  ##   The string must be double-quoted.
  ## * **status:`<enum>`**
  ##   For example: **status:active**
  ##   Returns beacons whose status matches the given value. Values must be
  ##   one of the Beacon.Status enum values (case insensitive). Accepts
  ##   multiple filters which will be combined with OR logic.
  ## * **stability:`<enum>`**
  ##   For example: **stability:mobile**
  ##   Returns beacons whose expected stability matches the given value.
  ##   Values must be one of the Beacon.Stability enum values (case
  ##   insensitive). Accepts multiple filters which will be combined with
  ##   OR logic.
  ## * **place\_id:`"<string>"`**
  ##   For example: **place\_id:"ChIJVSZzVR8FdkgRXGmmm6SslKw="**
  ##   Returns beacons explicitly registered at the given place, expressed as
  ##   a Place ID obtained from [Google Places API](/places/place-id). Does not
  ##   match places inside the given place. Does not consider the beacon's
  ##   actual location (which may be different from its registered place).
  ##   Accepts multiple filters that will be combined with OR logic. The place
  ##   ID must be double-quoted.
  ## * **registration\_time`[<|>|<=|>=]<integer>`**
  ##   For example: **registration\_time>=1433116800**
  ##   Returns beacons whose registration time matches the given filter.
  ##   Supports the operators: <, >, <=, and >=. Timestamp must be expressed as
  ##   an integer number of seconds since midnight January 1, 1970 UTC. Accepts
  ##   at most two filters that will be combined with AND logic, to support
  ##   "between" semantics. If more than two are supplied, the latter ones are
  ##   ignored.
  ## * **lat:`<double> lng:<double> radius:<integer>`**
  ##   For example: **lat:51.1232343 lng:-1.093852 radius:1000**
  ##   Returns beacons whose registered location is within the given circle.
  ##   When any of these fields are given, all are required. Latitude and
  ##   longitude must be decimal degrees between -90.0 and 90.0 and between
  ##   -180.0 and 180.0 respectively. Radius must be an integer number of
  ##   meters between 10 and 1,000,000 (1000 km).
  ## * **property:`"<string>=<string>"`**
  ##   For example: **property:"battery-type=CR2032"**
  ##   Returns beacons which have a property of the given name and value.
  ##   Supports multiple filters which will be combined with OR logic.
  ##   The entire name=value string must be double-quoted as one string.
  ## * **attachment\_type:`"<string>"`**
  ##   For example: **attachment_type:"my-namespace/my-type"**
  ##   Returns beacons having at least one attachment of the given namespaced
  ##   type. Supports "any within this namespace" via the partial wildcard
  ##   syntax: "my-namespace/*". Supports multiple filters which will be
  ##   combined with OR logic. The string must be double-quoted.
  ## * **indoor\_level:`"<string>"`**
  ##   For example: **indoor\_level:"1"**
  ##   Returns beacons which are located on the given indoor level. Accepts
  ##   multiple filters that will be combined with OR logic.
  ## 
  ## Multiple filters on the same field are combined with OR logic (except
  ## registration_time which is combined with AND logic).
  ## Multiple filters on different fields are combined with AND logic.
  ## Filters should be separated by spaces.
  ## 
  ## As with any HTTP query string parameter, the whole filter expression must
  ## be URL-encoded.
  ## 
  ## Example REST request:
  ## `GET /v1beta1/beacons?q=status:active%20lat:51.123%20lng:-1.095%20radius:1000`
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of records to return for this request, up to a
  ## server-defined upper limit.
  ##   projectId: JString
  ##            : The project id to list beacons under. If not present then the project
  ## credential that made the request is used as the project.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593954 = query.getOrDefault("upload_protocol")
  valid_593954 = validateParameter(valid_593954, JString, required = false,
                                 default = nil)
  if valid_593954 != nil:
    section.add "upload_protocol", valid_593954
  var valid_593955 = query.getOrDefault("fields")
  valid_593955 = validateParameter(valid_593955, JString, required = false,
                                 default = nil)
  if valid_593955 != nil:
    section.add "fields", valid_593955
  var valid_593956 = query.getOrDefault("pageToken")
  valid_593956 = validateParameter(valid_593956, JString, required = false,
                                 default = nil)
  if valid_593956 != nil:
    section.add "pageToken", valid_593956
  var valid_593957 = query.getOrDefault("quotaUser")
  valid_593957 = validateParameter(valid_593957, JString, required = false,
                                 default = nil)
  if valid_593957 != nil:
    section.add "quotaUser", valid_593957
  var valid_593958 = query.getOrDefault("alt")
  valid_593958 = validateParameter(valid_593958, JString, required = false,
                                 default = newJString("json"))
  if valid_593958 != nil:
    section.add "alt", valid_593958
  var valid_593959 = query.getOrDefault("oauth_token")
  valid_593959 = validateParameter(valid_593959, JString, required = false,
                                 default = nil)
  if valid_593959 != nil:
    section.add "oauth_token", valid_593959
  var valid_593960 = query.getOrDefault("callback")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = nil)
  if valid_593960 != nil:
    section.add "callback", valid_593960
  var valid_593961 = query.getOrDefault("access_token")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "access_token", valid_593961
  var valid_593962 = query.getOrDefault("uploadType")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "uploadType", valid_593962
  var valid_593963 = query.getOrDefault("q")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "q", valid_593963
  var valid_593964 = query.getOrDefault("key")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "key", valid_593964
  var valid_593965 = query.getOrDefault("$.xgafv")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = newJString("1"))
  if valid_593965 != nil:
    section.add "$.xgafv", valid_593965
  var valid_593966 = query.getOrDefault("pageSize")
  valid_593966 = validateParameter(valid_593966, JInt, required = false, default = nil)
  if valid_593966 != nil:
    section.add "pageSize", valid_593966
  var valid_593967 = query.getOrDefault("projectId")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "projectId", valid_593967
  var valid_593968 = query.getOrDefault("prettyPrint")
  valid_593968 = validateParameter(valid_593968, JBool, required = false,
                                 default = newJBool(true))
  if valid_593968 != nil:
    section.add "prettyPrint", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_ProximitybeaconBeaconsList_593951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_ProximitybeaconBeaconsList_593951;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          q: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          projectId: string = ""; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsList
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token obtained from a previous request to list beacons.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   q: string
  ##    : Filter query string that supports the following field filters:
  ## 
  ## * **description:`"<string>"`**
  ##   For example: **description:"Room 3"**
  ##   Returns beacons whose description matches tokens in the string "Room 3"
  ##   (not necessarily that exact string).
  ##   The string must be double-quoted.
  ## * **status:`<enum>`**
  ##   For example: **status:active**
  ##   Returns beacons whose status matches the given value. Values must be
  ##   one of the Beacon.Status enum values (case insensitive). Accepts
  ##   multiple filters which will be combined with OR logic.
  ## * **stability:`<enum>`**
  ##   For example: **stability:mobile**
  ##   Returns beacons whose expected stability matches the given value.
  ##   Values must be one of the Beacon.Stability enum values (case
  ##   insensitive). Accepts multiple filters which will be combined with
  ##   OR logic.
  ## * **place\_id:`"<string>"`**
  ##   For example: **place\_id:"ChIJVSZzVR8FdkgRXGmmm6SslKw="**
  ##   Returns beacons explicitly registered at the given place, expressed as
  ##   a Place ID obtained from [Google Places API](/places/place-id). Does not
  ##   match places inside the given place. Does not consider the beacon's
  ##   actual location (which may be different from its registered place).
  ##   Accepts multiple filters that will be combined with OR logic. The place
  ##   ID must be double-quoted.
  ## * **registration\_time`[<|>|<=|>=]<integer>`**
  ##   For example: **registration\_time>=1433116800**
  ##   Returns beacons whose registration time matches the given filter.
  ##   Supports the operators: <, >, <=, and >=. Timestamp must be expressed as
  ##   an integer number of seconds since midnight January 1, 1970 UTC. Accepts
  ##   at most two filters that will be combined with AND logic, to support
  ##   "between" semantics. If more than two are supplied, the latter ones are
  ##   ignored.
  ## * **lat:`<double> lng:<double> radius:<integer>`**
  ##   For example: **lat:51.1232343 lng:-1.093852 radius:1000**
  ##   Returns beacons whose registered location is within the given circle.
  ##   When any of these fields are given, all are required. Latitude and
  ##   longitude must be decimal degrees between -90.0 and 90.0 and between
  ##   -180.0 and 180.0 respectively. Radius must be an integer number of
  ##   meters between 10 and 1,000,000 (1000 km).
  ## * **property:`"<string>=<string>"`**
  ##   For example: **property:"battery-type=CR2032"**
  ##   Returns beacons which have a property of the given name and value.
  ##   Supports multiple filters which will be combined with OR logic.
  ##   The entire name=value string must be double-quoted as one string.
  ## * **attachment\_type:`"<string>"`**
  ##   For example: **attachment_type:"my-namespace/my-type"**
  ##   Returns beacons having at least one attachment of the given namespaced
  ##   type. Supports "any within this namespace" via the partial wildcard
  ##   syntax: "my-namespace/*". Supports multiple filters which will be
  ##   combined with OR logic. The string must be double-quoted.
  ## * **indoor\_level:`"<string>"`**
  ##   For example: **indoor\_level:"1"**
  ##   Returns beacons which are located on the given indoor level. Accepts
  ##   multiple filters that will be combined with OR logic.
  ## 
  ## Multiple filters on the same field are combined with OR logic (except
  ## registration_time which is combined with AND logic).
  ## Multiple filters on different fields are combined with AND logic.
  ## Filters should be separated by spaces.
  ## 
  ## As with any HTTP query string parameter, the whole filter expression must
  ## be URL-encoded.
  ## 
  ## Example REST request:
  ## `GET /v1beta1/beacons?q=status:active%20lat:51.123%20lng:-1.095%20radius:1000`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of records to return for this request, up to a
  ## server-defined upper limit.
  ##   projectId: string
  ##            : The project id to list beacons under. If not present then the project
  ## credential that made the request is used as the project.
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593971 = newJObject()
  add(query_593971, "upload_protocol", newJString(uploadProtocol))
  add(query_593971, "fields", newJString(fields))
  add(query_593971, "pageToken", newJString(pageToken))
  add(query_593971, "quotaUser", newJString(quotaUser))
  add(query_593971, "alt", newJString(alt))
  add(query_593971, "oauth_token", newJString(oauthToken))
  add(query_593971, "callback", newJString(callback))
  add(query_593971, "access_token", newJString(accessToken))
  add(query_593971, "uploadType", newJString(uploadType))
  add(query_593971, "q", newJString(q))
  add(query_593971, "key", newJString(key))
  add(query_593971, "$.xgafv", newJString(Xgafv))
  add(query_593971, "pageSize", newJInt(pageSize))
  add(query_593971, "projectId", newJString(projectId))
  add(query_593971, "prettyPrint", newJBool(prettyPrint))
  result = call_593970.call(nil, query_593971, nil, nil, nil)

var proximitybeaconBeaconsList* = Call_ProximitybeaconBeaconsList_593951(
    name: "proximitybeaconBeaconsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/beacons",
    validator: validate_ProximitybeaconBeaconsList_593952, base: "/",
    url: url_ProximitybeaconBeaconsList_593953, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsRegister_593972 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsRegister_593974(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconsRegister_593973(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the project the beacon will be registered to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593975 = query.getOrDefault("upload_protocol")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "upload_protocol", valid_593975
  var valid_593976 = query.getOrDefault("fields")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "fields", valid_593976
  var valid_593977 = query.getOrDefault("quotaUser")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "quotaUser", valid_593977
  var valid_593978 = query.getOrDefault("alt")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("json"))
  if valid_593978 != nil:
    section.add "alt", valid_593978
  var valid_593979 = query.getOrDefault("oauth_token")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "oauth_token", valid_593979
  var valid_593980 = query.getOrDefault("callback")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "callback", valid_593980
  var valid_593981 = query.getOrDefault("access_token")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "access_token", valid_593981
  var valid_593982 = query.getOrDefault("uploadType")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "uploadType", valid_593982
  var valid_593983 = query.getOrDefault("key")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "key", valid_593983
  var valid_593984 = query.getOrDefault("$.xgafv")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = newJString("1"))
  if valid_593984 != nil:
    section.add "$.xgafv", valid_593984
  var valid_593985 = query.getOrDefault("projectId")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "projectId", valid_593985
  var valid_593986 = query.getOrDefault("prettyPrint")
  valid_593986 = validateParameter(valid_593986, JBool, required = false,
                                 default = newJBool(true))
  if valid_593986 != nil:
    section.add "prettyPrint", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_ProximitybeaconBeaconsRegister_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_ProximitybeaconBeaconsRegister_593972;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; projectId: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsRegister
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the project the beacon will be registered to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593990 = newJObject()
  var body_593991 = newJObject()
  add(query_593990, "upload_protocol", newJString(uploadProtocol))
  add(query_593990, "fields", newJString(fields))
  add(query_593990, "quotaUser", newJString(quotaUser))
  add(query_593990, "alt", newJString(alt))
  add(query_593990, "oauth_token", newJString(oauthToken))
  add(query_593990, "callback", newJString(callback))
  add(query_593990, "access_token", newJString(accessToken))
  add(query_593990, "uploadType", newJString(uploadType))
  add(query_593990, "key", newJString(key))
  add(query_593990, "$.xgafv", newJString(Xgafv))
  add(query_593990, "projectId", newJString(projectId))
  if body != nil:
    body_593991 = body
  add(query_593990, "prettyPrint", newJBool(prettyPrint))
  result = call_593989.call(nil, query_593990, nil, nil, body_593991)

var proximitybeaconBeaconsRegister* = Call_ProximitybeaconBeaconsRegister_593972(
    name: "proximitybeaconBeaconsRegister", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/beacons:register",
    validator: validate_ProximitybeaconBeaconsRegister_593973, base: "/",
    url: url_ProximitybeaconBeaconsRegister_593974, schemes: {Scheme.Https})
type
  Call_ProximitybeaconGetEidparams_593992 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconGetEidparams_593994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProximitybeaconGetEidparams_593993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593995 = query.getOrDefault("upload_protocol")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "upload_protocol", valid_593995
  var valid_593996 = query.getOrDefault("fields")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "fields", valid_593996
  var valid_593997 = query.getOrDefault("quotaUser")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "quotaUser", valid_593997
  var valid_593998 = query.getOrDefault("alt")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = newJString("json"))
  if valid_593998 != nil:
    section.add "alt", valid_593998
  var valid_593999 = query.getOrDefault("oauth_token")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "oauth_token", valid_593999
  var valid_594000 = query.getOrDefault("callback")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "callback", valid_594000
  var valid_594001 = query.getOrDefault("access_token")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "access_token", valid_594001
  var valid_594002 = query.getOrDefault("uploadType")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "uploadType", valid_594002
  var valid_594003 = query.getOrDefault("key")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "key", valid_594003
  var valid_594004 = query.getOrDefault("$.xgafv")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("1"))
  if valid_594004 != nil:
    section.add "$.xgafv", valid_594004
  var valid_594005 = query.getOrDefault("prettyPrint")
  valid_594005 = validateParameter(valid_594005, JBool, required = false,
                                 default = newJBool(true))
  if valid_594005 != nil:
    section.add "prettyPrint", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_ProximitybeaconGetEidparams_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_ProximitybeaconGetEidparams_593992;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## proximitybeaconGetEidparams
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594008 = newJObject()
  add(query_594008, "upload_protocol", newJString(uploadProtocol))
  add(query_594008, "fields", newJString(fields))
  add(query_594008, "quotaUser", newJString(quotaUser))
  add(query_594008, "alt", newJString(alt))
  add(query_594008, "oauth_token", newJString(oauthToken))
  add(query_594008, "callback", newJString(callback))
  add(query_594008, "access_token", newJString(accessToken))
  add(query_594008, "uploadType", newJString(uploadType))
  add(query_594008, "key", newJString(key))
  add(query_594008, "$.xgafv", newJString(Xgafv))
  add(query_594008, "prettyPrint", newJBool(prettyPrint))
  result = call_594007.call(nil, query_594008, nil, nil, nil)

var proximitybeaconGetEidparams* = Call_ProximitybeaconGetEidparams_593992(
    name: "proximitybeaconGetEidparams", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/eidparams",
    validator: validate_ProximitybeaconGetEidparams_593993, base: "/",
    url: url_ProximitybeaconGetEidparams_593994, schemes: {Scheme.Https})
type
  Call_ProximitybeaconNamespacesList_594009 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconNamespacesList_594011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProximitybeaconNamespacesList_594010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id to list namespaces under.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594012 = query.getOrDefault("upload_protocol")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "upload_protocol", valid_594012
  var valid_594013 = query.getOrDefault("fields")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "fields", valid_594013
  var valid_594014 = query.getOrDefault("quotaUser")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "quotaUser", valid_594014
  var valid_594015 = query.getOrDefault("alt")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("json"))
  if valid_594015 != nil:
    section.add "alt", valid_594015
  var valid_594016 = query.getOrDefault("oauth_token")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "oauth_token", valid_594016
  var valid_594017 = query.getOrDefault("callback")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "callback", valid_594017
  var valid_594018 = query.getOrDefault("access_token")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "access_token", valid_594018
  var valid_594019 = query.getOrDefault("uploadType")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "uploadType", valid_594019
  var valid_594020 = query.getOrDefault("key")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "key", valid_594020
  var valid_594021 = query.getOrDefault("$.xgafv")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = newJString("1"))
  if valid_594021 != nil:
    section.add "$.xgafv", valid_594021
  var valid_594022 = query.getOrDefault("projectId")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "projectId", valid_594022
  var valid_594023 = query.getOrDefault("prettyPrint")
  valid_594023 = validateParameter(valid_594023, JBool, required = false,
                                 default = newJBool(true))
  if valid_594023 != nil:
    section.add "prettyPrint", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_ProximitybeaconNamespacesList_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_ProximitybeaconNamespacesList_594009;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; projectId: string = ""; prettyPrint: bool = true): Recallable =
  ## proximitybeaconNamespacesList
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id to list namespaces under.
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594026 = newJObject()
  add(query_594026, "upload_protocol", newJString(uploadProtocol))
  add(query_594026, "fields", newJString(fields))
  add(query_594026, "quotaUser", newJString(quotaUser))
  add(query_594026, "alt", newJString(alt))
  add(query_594026, "oauth_token", newJString(oauthToken))
  add(query_594026, "callback", newJString(callback))
  add(query_594026, "access_token", newJString(accessToken))
  add(query_594026, "uploadType", newJString(uploadType))
  add(query_594026, "key", newJString(key))
  add(query_594026, "$.xgafv", newJString(Xgafv))
  add(query_594026, "projectId", newJString(projectId))
  add(query_594026, "prettyPrint", newJBool(prettyPrint))
  result = call_594025.call(nil, query_594026, nil, nil, nil)

var proximitybeaconNamespacesList* = Call_ProximitybeaconNamespacesList_594009(
    name: "proximitybeaconNamespacesList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/namespaces",
    validator: validate_ProximitybeaconNamespacesList_594010, base: "/",
    url: url_ProximitybeaconNamespacesList_594011, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsDelete_594027 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsAttachmentsDelete_594029(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "attachmentName" in path, "`attachmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "attachmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsDelete_594028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified attachment for the given beacon. Each attachment has
  ## a unique attachment name (`attachmentName`) which is returned when you
  ## fetch the attachment data via this API. You specify this with the delete
  ## request to control which attachment is removed. This operation cannot be
  ## undone.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentName: JString (required)
  ##                 : The attachment name (`attachmentName`) of
  ## the attachment to remove. For example:
  ## `beacons/3!893737abc9/attachments/c5e937-af0-494-959-ec49d12738`. For
  ## Eddystone-EID beacons, the beacon ID portion (`3!893737abc9`) may be the
  ## beacon's current EID, or its "stable" Eddystone-UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentName` field"
  var valid_594044 = path.getOrDefault("attachmentName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "attachmentName", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the attachment to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594045 = query.getOrDefault("upload_protocol")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "upload_protocol", valid_594045
  var valid_594046 = query.getOrDefault("fields")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "fields", valid_594046
  var valid_594047 = query.getOrDefault("quotaUser")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "quotaUser", valid_594047
  var valid_594048 = query.getOrDefault("alt")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = newJString("json"))
  if valid_594048 != nil:
    section.add "alt", valid_594048
  var valid_594049 = query.getOrDefault("oauth_token")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "oauth_token", valid_594049
  var valid_594050 = query.getOrDefault("callback")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "callback", valid_594050
  var valid_594051 = query.getOrDefault("access_token")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "access_token", valid_594051
  var valid_594052 = query.getOrDefault("uploadType")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "uploadType", valid_594052
  var valid_594053 = query.getOrDefault("key")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "key", valid_594053
  var valid_594054 = query.getOrDefault("$.xgafv")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = newJString("1"))
  if valid_594054 != nil:
    section.add "$.xgafv", valid_594054
  var valid_594055 = query.getOrDefault("projectId")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "projectId", valid_594055
  var valid_594056 = query.getOrDefault("prettyPrint")
  valid_594056 = validateParameter(valid_594056, JBool, required = false,
                                 default = newJBool(true))
  if valid_594056 != nil:
    section.add "prettyPrint", valid_594056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594057: Call_ProximitybeaconBeaconsAttachmentsDelete_594027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified attachment for the given beacon. Each attachment has
  ## a unique attachment name (`attachmentName`) which is returned when you
  ## fetch the attachment data via this API. You specify this with the delete
  ## request to control which attachment is removed. This operation cannot be
  ## undone.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_ProximitybeaconBeaconsAttachmentsDelete_594027;
          attachmentName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsAttachmentsDelete
  ## Deletes the specified attachment for the given beacon. Each attachment has
  ## a unique attachment name (`attachmentName`) which is returned when you
  ## fetch the attachment data via this API. You specify this with the delete
  ## request to control which attachment is removed. This operation cannot be
  ## undone.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   attachmentName: string (required)
  ##                 : The attachment name (`attachmentName`) of
  ## the attachment to remove. For example:
  ## `beacons/3!893737abc9/attachments/c5e937-af0-494-959-ec49d12738`. For
  ## Eddystone-EID beacons, the beacon ID portion (`3!893737abc9`) may be the
  ## beacon's current EID, or its "stable" Eddystone-UID.
  ## Required.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the attachment to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  add(query_594060, "upload_protocol", newJString(uploadProtocol))
  add(query_594060, "fields", newJString(fields))
  add(query_594060, "quotaUser", newJString(quotaUser))
  add(path_594059, "attachmentName", newJString(attachmentName))
  add(query_594060, "alt", newJString(alt))
  add(query_594060, "oauth_token", newJString(oauthToken))
  add(query_594060, "callback", newJString(callback))
  add(query_594060, "access_token", newJString(accessToken))
  add(query_594060, "uploadType", newJString(uploadType))
  add(query_594060, "key", newJString(key))
  add(query_594060, "$.xgafv", newJString(Xgafv))
  add(query_594060, "projectId", newJString(projectId))
  add(query_594060, "prettyPrint", newJBool(prettyPrint))
  result = call_594058.call(path_594059, query_594060, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsDelete* = Call_ProximitybeaconBeaconsAttachmentsDelete_594027(
    name: "proximitybeaconBeaconsAttachmentsDelete", meth: HttpMethod.HttpDelete,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{attachmentName}",
    validator: validate_ProximitybeaconBeaconsAttachmentsDelete_594028, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsDelete_594029,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsUpdate_594081 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsUpdate_594083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsUpdate_594082(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the information about the specified beacon. **Any field that you do
  ## not populate in the submitted beacon will be permanently erased**, so you
  ## should follow the "read, modify, write" pattern to avoid inadvertently
  ## destroying data.
  ## 
  ## Changes to the beacon status via this method will be  silently ignored.
  ## To update beacon status, use the separate methods on this API for
  ## activation, deactivation, and decommissioning.
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone, `1` for iBeacon, or `5` for AltBeacon.
  ## 
  ## This field must be left empty when registering. After reading a beacon,
  ## clients can use the name for future operations.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594084 = path.getOrDefault("beaconName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "beaconName", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594085 = query.getOrDefault("upload_protocol")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "upload_protocol", valid_594085
  var valid_594086 = query.getOrDefault("fields")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "fields", valid_594086
  var valid_594087 = query.getOrDefault("quotaUser")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "quotaUser", valid_594087
  var valid_594088 = query.getOrDefault("alt")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = newJString("json"))
  if valid_594088 != nil:
    section.add "alt", valid_594088
  var valid_594089 = query.getOrDefault("oauth_token")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "oauth_token", valid_594089
  var valid_594090 = query.getOrDefault("callback")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "callback", valid_594090
  var valid_594091 = query.getOrDefault("access_token")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "access_token", valid_594091
  var valid_594092 = query.getOrDefault("uploadType")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "uploadType", valid_594092
  var valid_594093 = query.getOrDefault("key")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "key", valid_594093
  var valid_594094 = query.getOrDefault("$.xgafv")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("1"))
  if valid_594094 != nil:
    section.add "$.xgafv", valid_594094
  var valid_594095 = query.getOrDefault("projectId")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "projectId", valid_594095
  var valid_594096 = query.getOrDefault("prettyPrint")
  valid_594096 = validateParameter(valid_594096, JBool, required = false,
                                 default = newJBool(true))
  if valid_594096 != nil:
    section.add "prettyPrint", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_ProximitybeaconBeaconsUpdate_594081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the information about the specified beacon. **Any field that you do
  ## not populate in the submitted beacon will be permanently erased**, so you
  ## should follow the "read, modify, write" pattern to avoid inadvertently
  ## destroying data.
  ## 
  ## Changes to the beacon status via this method will be  silently ignored.
  ## To update beacon status, use the separate methods on this API for
  ## activation, deactivation, and decommissioning.
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_ProximitybeaconBeaconsUpdate_594081;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsUpdate
  ## Updates the information about the specified beacon. **Any field that you do
  ## not populate in the submitted beacon will be permanently erased**, so you
  ## should follow the "read, modify, write" pattern to avoid inadvertently
  ## destroying data.
  ## 
  ## Changes to the beacon status via this method will be  silently ignored.
  ## To update beacon status, use the separate methods on this API for
  ## activation, deactivation, and decommissioning.
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone, `1` for iBeacon, or `5` for AltBeacon.
  ## 
  ## This field must be left empty when registering. After reading a beacon,
  ## clients can use the name for future operations.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  var body_594102 = newJObject()
  add(query_594101, "upload_protocol", newJString(uploadProtocol))
  add(query_594101, "fields", newJString(fields))
  add(query_594101, "quotaUser", newJString(quotaUser))
  add(query_594101, "alt", newJString(alt))
  add(query_594101, "oauth_token", newJString(oauthToken))
  add(query_594101, "callback", newJString(callback))
  add(query_594101, "access_token", newJString(accessToken))
  add(query_594101, "uploadType", newJString(uploadType))
  add(query_594101, "key", newJString(key))
  add(query_594101, "$.xgafv", newJString(Xgafv))
  add(query_594101, "projectId", newJString(projectId))
  add(path_594100, "beaconName", newJString(beaconName))
  if body != nil:
    body_594102 = body
  add(query_594101, "prettyPrint", newJBool(prettyPrint))
  result = call_594099.call(path_594100, query_594101, nil, nil, body_594102)

var proximitybeaconBeaconsUpdate* = Call_ProximitybeaconBeaconsUpdate_594081(
    name: "proximitybeaconBeaconsUpdate", meth: HttpMethod.HttpPut,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsUpdate_594082, base: "/",
    url: url_ProximitybeaconBeaconsUpdate_594083, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsGet_594061 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsGet_594063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsGet_594062(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns detailed information about the specified beacon.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  ## Requests may supply an Eddystone-EID beacon name in the form:
  ## `beacons/4!beaconId` where the `beaconId` is the base16 ephemeral ID
  ## broadcast by the beacon. The returned `Beacon` object will contain the
  ## beacon's stable Eddystone-UID. Clients not authorized to resolve the
  ## beacon's ephemeral Eddystone-EID broadcast will receive an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594064 = path.getOrDefault("beaconName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "beaconName", valid_594064
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to request. If the project id is not specified
  ## then the project making the request is used. The project id must match the
  ## project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594065 = query.getOrDefault("upload_protocol")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "upload_protocol", valid_594065
  var valid_594066 = query.getOrDefault("fields")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "fields", valid_594066
  var valid_594067 = query.getOrDefault("quotaUser")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "quotaUser", valid_594067
  var valid_594068 = query.getOrDefault("alt")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = newJString("json"))
  if valid_594068 != nil:
    section.add "alt", valid_594068
  var valid_594069 = query.getOrDefault("oauth_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "oauth_token", valid_594069
  var valid_594070 = query.getOrDefault("callback")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "callback", valid_594070
  var valid_594071 = query.getOrDefault("access_token")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "access_token", valid_594071
  var valid_594072 = query.getOrDefault("uploadType")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "uploadType", valid_594072
  var valid_594073 = query.getOrDefault("key")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "key", valid_594073
  var valid_594074 = query.getOrDefault("$.xgafv")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = newJString("1"))
  if valid_594074 != nil:
    section.add "$.xgafv", valid_594074
  var valid_594075 = query.getOrDefault("projectId")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "projectId", valid_594075
  var valid_594076 = query.getOrDefault("prettyPrint")
  valid_594076 = validateParameter(valid_594076, JBool, required = false,
                                 default = newJBool(true))
  if valid_594076 != nil:
    section.add "prettyPrint", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_ProximitybeaconBeaconsGet_594061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns detailed information about the specified beacon.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  ## Requests may supply an Eddystone-EID beacon name in the form:
  ## `beacons/4!beaconId` where the `beaconId` is the base16 ephemeral ID
  ## broadcast by the beacon. The returned `Beacon` object will contain the
  ## beacon's stable Eddystone-UID. Clients not authorized to resolve the
  ## beacon's ephemeral Eddystone-EID broadcast will receive an error.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_ProximitybeaconBeaconsGet_594061; beaconName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; projectId: string = ""; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsGet
  ## Returns detailed information about the specified beacon.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  ## Requests may supply an Eddystone-EID beacon name in the form:
  ## `beacons/4!beaconId` where the `beaconId` is the base16 ephemeral ID
  ## broadcast by the beacon. The returned `Beacon` object will contain the
  ## beacon's stable Eddystone-UID. Clients not authorized to resolve the
  ## beacon's ephemeral Eddystone-EID broadcast will receive an error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to request. If the project id is not specified
  ## then the project making the request is used. The project id must match the
  ## project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  add(query_594080, "upload_protocol", newJString(uploadProtocol))
  add(query_594080, "fields", newJString(fields))
  add(query_594080, "quotaUser", newJString(quotaUser))
  add(query_594080, "alt", newJString(alt))
  add(query_594080, "oauth_token", newJString(oauthToken))
  add(query_594080, "callback", newJString(callback))
  add(query_594080, "access_token", newJString(accessToken))
  add(query_594080, "uploadType", newJString(uploadType))
  add(query_594080, "key", newJString(key))
  add(query_594080, "$.xgafv", newJString(Xgafv))
  add(query_594080, "projectId", newJString(projectId))
  add(path_594079, "beaconName", newJString(beaconName))
  add(query_594080, "prettyPrint", newJBool(prettyPrint))
  result = call_594078.call(path_594079, query_594080, nil, nil, nil)

var proximitybeaconBeaconsGet* = Call_ProximitybeaconBeaconsGet_594061(
    name: "proximitybeaconBeaconsGet", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsGet_594062, base: "/",
    url: url_ProximitybeaconBeaconsGet_594063, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDelete_594103 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsDelete_594105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDelete_594104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be deleted. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594106 = path.getOrDefault("beaconName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "beaconName", valid_594106
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594107 = query.getOrDefault("upload_protocol")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "upload_protocol", valid_594107
  var valid_594108 = query.getOrDefault("fields")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "fields", valid_594108
  var valid_594109 = query.getOrDefault("quotaUser")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "quotaUser", valid_594109
  var valid_594110 = query.getOrDefault("alt")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = newJString("json"))
  if valid_594110 != nil:
    section.add "alt", valid_594110
  var valid_594111 = query.getOrDefault("oauth_token")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "oauth_token", valid_594111
  var valid_594112 = query.getOrDefault("callback")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "callback", valid_594112
  var valid_594113 = query.getOrDefault("access_token")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "access_token", valid_594113
  var valid_594114 = query.getOrDefault("uploadType")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "uploadType", valid_594114
  var valid_594115 = query.getOrDefault("key")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "key", valid_594115
  var valid_594116 = query.getOrDefault("$.xgafv")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = newJString("1"))
  if valid_594116 != nil:
    section.add "$.xgafv", valid_594116
  var valid_594117 = query.getOrDefault("projectId")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "projectId", valid_594117
  var valid_594118 = query.getOrDefault("prettyPrint")
  valid_594118 = validateParameter(valid_594118, JBool, required = false,
                                 default = newJBool(true))
  if valid_594118 != nil:
    section.add "prettyPrint", valid_594118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594119: Call_ProximitybeaconBeaconsDelete_594103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_594119.validator(path, query, header, formData, body)
  let scheme = call_594119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594119.url(scheme.get, call_594119.host, call_594119.base,
                         call_594119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594119, url, valid)

proc call*(call_594120: Call_ProximitybeaconBeaconsDelete_594103;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsDelete
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon that should be deleted. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594121 = newJObject()
  var query_594122 = newJObject()
  add(query_594122, "upload_protocol", newJString(uploadProtocol))
  add(query_594122, "fields", newJString(fields))
  add(query_594122, "quotaUser", newJString(quotaUser))
  add(query_594122, "alt", newJString(alt))
  add(query_594122, "oauth_token", newJString(oauthToken))
  add(query_594122, "callback", newJString(callback))
  add(query_594122, "access_token", newJString(accessToken))
  add(query_594122, "uploadType", newJString(uploadType))
  add(query_594122, "key", newJString(key))
  add(query_594122, "$.xgafv", newJString(Xgafv))
  add(query_594122, "projectId", newJString(projectId))
  add(path_594121, "beaconName", newJString(beaconName))
  add(query_594122, "prettyPrint", newJBool(prettyPrint))
  result = call_594120.call(path_594121, query_594122, nil, nil, nil)

var proximitybeaconBeaconsDelete* = Call_ProximitybeaconBeaconsDelete_594103(
    name: "proximitybeaconBeaconsDelete", meth: HttpMethod.HttpDelete,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsDelete_594104, base: "/",
    url: url_ProximitybeaconBeaconsDelete_594105, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsCreate_594144 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsAttachmentsCreate_594146(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsCreate_594145(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Associates the given data with the specified beacon. Attachment data must
  ## contain two parts:
  ## <ul>
  ## <li>A namespaced type.</li>
  ## <li>The actual attachment data itself.</li>
  ## </ul>
  ## The namespaced type consists of two parts, the namespace and the type.
  ## The namespace must be one of the values returned by the `namespaces`
  ## endpoint, while the type can be a string of any characters except for the
  ## forward slash (`/`) up to 100 characters in length.
  ## 
  ## Attachment data can be up to 1024 bytes long.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon on which the attachment should be created. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594147 = path.getOrDefault("beaconName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "beaconName", valid_594147
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the project the attachment will belong to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594148 = query.getOrDefault("upload_protocol")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "upload_protocol", valid_594148
  var valid_594149 = query.getOrDefault("fields")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "fields", valid_594149
  var valid_594150 = query.getOrDefault("quotaUser")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "quotaUser", valid_594150
  var valid_594151 = query.getOrDefault("alt")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = newJString("json"))
  if valid_594151 != nil:
    section.add "alt", valid_594151
  var valid_594152 = query.getOrDefault("oauth_token")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "oauth_token", valid_594152
  var valid_594153 = query.getOrDefault("callback")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "callback", valid_594153
  var valid_594154 = query.getOrDefault("access_token")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "access_token", valid_594154
  var valid_594155 = query.getOrDefault("uploadType")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "uploadType", valid_594155
  var valid_594156 = query.getOrDefault("key")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "key", valid_594156
  var valid_594157 = query.getOrDefault("$.xgafv")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = newJString("1"))
  if valid_594157 != nil:
    section.add "$.xgafv", valid_594157
  var valid_594158 = query.getOrDefault("projectId")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "projectId", valid_594158
  var valid_594159 = query.getOrDefault("prettyPrint")
  valid_594159 = validateParameter(valid_594159, JBool, required = false,
                                 default = newJBool(true))
  if valid_594159 != nil:
    section.add "prettyPrint", valid_594159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594161: Call_ProximitybeaconBeaconsAttachmentsCreate_594144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates the given data with the specified beacon. Attachment data must
  ## contain two parts:
  ## <ul>
  ## <li>A namespaced type.</li>
  ## <li>The actual attachment data itself.</li>
  ## </ul>
  ## The namespaced type consists of two parts, the namespace and the type.
  ## The namespace must be one of the values returned by the `namespaces`
  ## endpoint, while the type can be a string of any characters except for the
  ## forward slash (`/`) up to 100 characters in length.
  ## 
  ## Attachment data can be up to 1024 bytes long.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_ProximitybeaconBeaconsAttachmentsCreate_594144;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsAttachmentsCreate
  ## Associates the given data with the specified beacon. Attachment data must
  ## contain two parts:
  ## <ul>
  ## <li>A namespaced type.</li>
  ## <li>The actual attachment data itself.</li>
  ## </ul>
  ## The namespaced type consists of two parts, the namespace and the type.
  ## The namespace must be one of the values returned by the `namespaces`
  ## endpoint, while the type can be a string of any characters except for the
  ## forward slash (`/`) up to 100 characters in length.
  ## 
  ## Attachment data can be up to 1024 bytes long.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the project the attachment will belong to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon on which the attachment should be created. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  var body_594165 = newJObject()
  add(query_594164, "upload_protocol", newJString(uploadProtocol))
  add(query_594164, "fields", newJString(fields))
  add(query_594164, "quotaUser", newJString(quotaUser))
  add(query_594164, "alt", newJString(alt))
  add(query_594164, "oauth_token", newJString(oauthToken))
  add(query_594164, "callback", newJString(callback))
  add(query_594164, "access_token", newJString(accessToken))
  add(query_594164, "uploadType", newJString(uploadType))
  add(query_594164, "key", newJString(key))
  add(query_594164, "$.xgafv", newJString(Xgafv))
  add(query_594164, "projectId", newJString(projectId))
  add(path_594163, "beaconName", newJString(beaconName))
  if body != nil:
    body_594165 = body
  add(query_594164, "prettyPrint", newJBool(prettyPrint))
  result = call_594162.call(path_594163, query_594164, nil, nil, body_594165)

var proximitybeaconBeaconsAttachmentsCreate* = Call_ProximitybeaconBeaconsAttachmentsCreate_594144(
    name: "proximitybeaconBeaconsAttachmentsCreate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments",
    validator: validate_ProximitybeaconBeaconsAttachmentsCreate_594145, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsCreate_594146,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsList_594123 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsAttachmentsList_594125(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsList_594124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the attachments for the specified beacon that match the specified
  ## namespaced-type pattern.
  ## 
  ## To control which namespaced types are returned, you add the
  ## `namespacedType` query parameter to the request. You must either use
  ## `*/*`, to return all attachments, or the namespace must be one of
  ## the ones returned from the  `namespaces` endpoint.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon whose attachments should be fetched. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594126 = path.getOrDefault("beaconName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "beaconName", valid_594126
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id to list beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   namespacedType: JString
  ##                 : Specifies the namespace and type of attachment to include in response in
  ## <var>namespace/type</var> format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  section = newJObject()
  var valid_594127 = query.getOrDefault("upload_protocol")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "upload_protocol", valid_594127
  var valid_594128 = query.getOrDefault("fields")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "fields", valid_594128
  var valid_594129 = query.getOrDefault("quotaUser")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "quotaUser", valid_594129
  var valid_594130 = query.getOrDefault("alt")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = newJString("json"))
  if valid_594130 != nil:
    section.add "alt", valid_594130
  var valid_594131 = query.getOrDefault("oauth_token")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "oauth_token", valid_594131
  var valid_594132 = query.getOrDefault("callback")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "callback", valid_594132
  var valid_594133 = query.getOrDefault("access_token")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "access_token", valid_594133
  var valid_594134 = query.getOrDefault("uploadType")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "uploadType", valid_594134
  var valid_594135 = query.getOrDefault("key")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "key", valid_594135
  var valid_594136 = query.getOrDefault("$.xgafv")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = newJString("1"))
  if valid_594136 != nil:
    section.add "$.xgafv", valid_594136
  var valid_594137 = query.getOrDefault("projectId")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "projectId", valid_594137
  var valid_594138 = query.getOrDefault("prettyPrint")
  valid_594138 = validateParameter(valid_594138, JBool, required = false,
                                 default = newJBool(true))
  if valid_594138 != nil:
    section.add "prettyPrint", valid_594138
  var valid_594139 = query.getOrDefault("namespacedType")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "namespacedType", valid_594139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594140: Call_ProximitybeaconBeaconsAttachmentsList_594123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the attachments for the specified beacon that match the specified
  ## namespaced-type pattern.
  ## 
  ## To control which namespaced types are returned, you add the
  ## `namespacedType` query parameter to the request. You must either use
  ## `*/*`, to return all attachments, or the namespace must be one of
  ## the ones returned from the  `namespaces` endpoint.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_ProximitybeaconBeaconsAttachmentsList_594123;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; namespacedType: string = ""): Recallable =
  ## proximitybeaconBeaconsAttachmentsList
  ## Returns the attachments for the specified beacon that match the specified
  ## namespaced-type pattern.
  ## 
  ## To control which namespaced types are returned, you add the
  ## `namespacedType` query parameter to the request. You must either use
  ## `*/*`, to return all attachments, or the namespace must be one of
  ## the ones returned from the  `namespaces` endpoint.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id to list beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon whose attachments should be fetched. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   namespacedType: string
  ##                 : Specifies the namespace and type of attachment to include in response in
  ## <var>namespace/type</var> format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  add(query_594143, "upload_protocol", newJString(uploadProtocol))
  add(query_594143, "fields", newJString(fields))
  add(query_594143, "quotaUser", newJString(quotaUser))
  add(query_594143, "alt", newJString(alt))
  add(query_594143, "oauth_token", newJString(oauthToken))
  add(query_594143, "callback", newJString(callback))
  add(query_594143, "access_token", newJString(accessToken))
  add(query_594143, "uploadType", newJString(uploadType))
  add(query_594143, "key", newJString(key))
  add(query_594143, "$.xgafv", newJString(Xgafv))
  add(query_594143, "projectId", newJString(projectId))
  add(path_594142, "beaconName", newJString(beaconName))
  add(query_594143, "prettyPrint", newJBool(prettyPrint))
  add(query_594143, "namespacedType", newJString(namespacedType))
  result = call_594141.call(path_594142, query_594143, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsList* = Call_ProximitybeaconBeaconsAttachmentsList_594123(
    name: "proximitybeaconBeaconsAttachmentsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments",
    validator: validate_ProximitybeaconBeaconsAttachmentsList_594124, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsList_594125, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsBatchDelete_594166 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsAttachmentsBatchDelete_594168(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/attachments:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsBatchDelete_594167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes multiple attachments on a given beacon. This operation is
  ## permanent and cannot be undone.
  ## 
  ## You can optionally specify `namespacedType` to choose which attachments
  ## should be deleted. If you do not specify `namespacedType`,  all your
  ## attachments on the given beacon will be deleted. You also may explicitly
  ## specify `*/*` to delete all.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : The beacon whose attachments should be deleted. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594169 = path.getOrDefault("beaconName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "beaconName", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id to delete beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   namespacedType: JString
  ##                 : Specifies the namespace and type of attachments to delete in
  ## `namespace/type` format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  ## Optional.
  section = newJObject()
  var valid_594170 = query.getOrDefault("upload_protocol")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "upload_protocol", valid_594170
  var valid_594171 = query.getOrDefault("fields")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "fields", valid_594171
  var valid_594172 = query.getOrDefault("quotaUser")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "quotaUser", valid_594172
  var valid_594173 = query.getOrDefault("alt")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = newJString("json"))
  if valid_594173 != nil:
    section.add "alt", valid_594173
  var valid_594174 = query.getOrDefault("oauth_token")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "oauth_token", valid_594174
  var valid_594175 = query.getOrDefault("callback")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "callback", valid_594175
  var valid_594176 = query.getOrDefault("access_token")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "access_token", valid_594176
  var valid_594177 = query.getOrDefault("uploadType")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "uploadType", valid_594177
  var valid_594178 = query.getOrDefault("key")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "key", valid_594178
  var valid_594179 = query.getOrDefault("$.xgafv")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = newJString("1"))
  if valid_594179 != nil:
    section.add "$.xgafv", valid_594179
  var valid_594180 = query.getOrDefault("projectId")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "projectId", valid_594180
  var valid_594181 = query.getOrDefault("prettyPrint")
  valid_594181 = validateParameter(valid_594181, JBool, required = false,
                                 default = newJBool(true))
  if valid_594181 != nil:
    section.add "prettyPrint", valid_594181
  var valid_594182 = query.getOrDefault("namespacedType")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "namespacedType", valid_594182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594183: Call_ProximitybeaconBeaconsAttachmentsBatchDelete_594166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes multiple attachments on a given beacon. This operation is
  ## permanent and cannot be undone.
  ## 
  ## You can optionally specify `namespacedType` to choose which attachments
  ## should be deleted. If you do not specify `namespacedType`,  all your
  ## attachments on the given beacon will be deleted. You also may explicitly
  ## specify `*/*` to delete all.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_594183.validator(path, query, header, formData, body)
  let scheme = call_594183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594183.url(scheme.get, call_594183.host, call_594183.base,
                         call_594183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594183, url, valid)

proc call*(call_594184: Call_ProximitybeaconBeaconsAttachmentsBatchDelete_594166;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; namespacedType: string = ""): Recallable =
  ## proximitybeaconBeaconsAttachmentsBatchDelete
  ## Deletes multiple attachments on a given beacon. This operation is
  ## permanent and cannot be undone.
  ## 
  ## You can optionally specify `namespacedType` to choose which attachments
  ## should be deleted. If you do not specify `namespacedType`,  all your
  ## attachments on the given beacon will be deleted. You also may explicitly
  ## specify `*/*` to delete all.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id to delete beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  ##   beaconName: string (required)
  ##             : The beacon whose attachments should be deleted. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   namespacedType: string
  ##                 : Specifies the namespace and type of attachments to delete in
  ## `namespace/type` format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  ## Optional.
  var path_594185 = newJObject()
  var query_594186 = newJObject()
  add(query_594186, "upload_protocol", newJString(uploadProtocol))
  add(query_594186, "fields", newJString(fields))
  add(query_594186, "quotaUser", newJString(quotaUser))
  add(query_594186, "alt", newJString(alt))
  add(query_594186, "oauth_token", newJString(oauthToken))
  add(query_594186, "callback", newJString(callback))
  add(query_594186, "access_token", newJString(accessToken))
  add(query_594186, "uploadType", newJString(uploadType))
  add(query_594186, "key", newJString(key))
  add(query_594186, "$.xgafv", newJString(Xgafv))
  add(query_594186, "projectId", newJString(projectId))
  add(path_594185, "beaconName", newJString(beaconName))
  add(query_594186, "prettyPrint", newJBool(prettyPrint))
  add(query_594186, "namespacedType", newJString(namespacedType))
  result = call_594184.call(path_594185, query_594186, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsBatchDelete* = Call_ProximitybeaconBeaconsAttachmentsBatchDelete_594166(
    name: "proximitybeaconBeaconsAttachmentsBatchDelete",
    meth: HttpMethod.HttpPost, host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments:batchDelete",
    validator: validate_ProximitybeaconBeaconsAttachmentsBatchDelete_594167,
    base: "/", url: url_ProximitybeaconBeaconsAttachmentsBatchDelete_594168,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDiagnosticsList_594187 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsDiagnosticsList_594189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/diagnostics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDiagnosticsList_594188(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the diagnostics for a single beacon. You can also list diagnostics for
  ## all the beacons owned by your Google Developers Console project by using
  ## the beacon name `beacons/-`.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that the diagnostics are for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594190 = path.getOrDefault("beaconName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "beaconName", valid_594190
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   alertFilter: JString
  ##              : Requests only beacons that have the given alert. For example, to find
  ## beacons that have low batteries use `alert_filter=LOW_BATTERY`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Requests results that occur after the `page_token`, obtained from the
  ## response to a previous request. Optional.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Specifies the maximum number of results to return. Defaults to
  ## 10. Maximum 1000. Optional.
  ##   projectId: JString
  ##            : Requests only diagnostic records for the given project id. If not set,
  ## then the project making the request will be used for looking up
  ## diagnostic records. Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594191 = query.getOrDefault("upload_protocol")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "upload_protocol", valid_594191
  var valid_594192 = query.getOrDefault("fields")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "fields", valid_594192
  var valid_594193 = query.getOrDefault("alertFilter")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = newJString("ALERT_UNSPECIFIED"))
  if valid_594193 != nil:
    section.add "alertFilter", valid_594193
  var valid_594194 = query.getOrDefault("quotaUser")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "quotaUser", valid_594194
  var valid_594195 = query.getOrDefault("pageToken")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "pageToken", valid_594195
  var valid_594196 = query.getOrDefault("alt")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = newJString("json"))
  if valid_594196 != nil:
    section.add "alt", valid_594196
  var valid_594197 = query.getOrDefault("oauth_token")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "oauth_token", valid_594197
  var valid_594198 = query.getOrDefault("callback")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "callback", valid_594198
  var valid_594199 = query.getOrDefault("access_token")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "access_token", valid_594199
  var valid_594200 = query.getOrDefault("uploadType")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "uploadType", valid_594200
  var valid_594201 = query.getOrDefault("key")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "key", valid_594201
  var valid_594202 = query.getOrDefault("$.xgafv")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = newJString("1"))
  if valid_594202 != nil:
    section.add "$.xgafv", valid_594202
  var valid_594203 = query.getOrDefault("pageSize")
  valid_594203 = validateParameter(valid_594203, JInt, required = false, default = nil)
  if valid_594203 != nil:
    section.add "pageSize", valid_594203
  var valid_594204 = query.getOrDefault("projectId")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "projectId", valid_594204
  var valid_594205 = query.getOrDefault("prettyPrint")
  valid_594205 = validateParameter(valid_594205, JBool, required = false,
                                 default = newJBool(true))
  if valid_594205 != nil:
    section.add "prettyPrint", valid_594205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594206: Call_ProximitybeaconBeaconsDiagnosticsList_594187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the diagnostics for a single beacon. You can also list diagnostics for
  ## all the beacons owned by your Google Developers Console project by using
  ## the beacon name `beacons/-`.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  let valid = call_594206.validator(path, query, header, formData, body)
  let scheme = call_594206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594206.url(scheme.get, call_594206.host, call_594206.base,
                         call_594206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594206, url, valid)

proc call*(call_594207: Call_ProximitybeaconBeaconsDiagnosticsList_594187;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          alertFilter: string = "ALERT_UNSPECIFIED"; quotaUser: string = "";
          pageToken: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsDiagnosticsList
  ## List the diagnostics for a single beacon. You can also list diagnostics for
  ## all the beacons owned by your Google Developers Console project by using
  ## the beacon name `beacons/-`.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   alertFilter: string
  ##              : Requests only beacons that have the given alert. For example, to find
  ## beacons that have low batteries use `alert_filter=LOW_BATTERY`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Requests results that occur after the `page_token`, obtained from the
  ## response to a previous request. Optional.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the maximum number of results to return. Defaults to
  ## 10. Maximum 1000. Optional.
  ##   projectId: string
  ##            : Requests only diagnostic records for the given project id. If not set,
  ## then the project making the request will be used for looking up
  ## diagnostic records. Optional.
  ##   beaconName: string (required)
  ##             : Beacon that the diagnostics are for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594208 = newJObject()
  var query_594209 = newJObject()
  add(query_594209, "upload_protocol", newJString(uploadProtocol))
  add(query_594209, "fields", newJString(fields))
  add(query_594209, "alertFilter", newJString(alertFilter))
  add(query_594209, "quotaUser", newJString(quotaUser))
  add(query_594209, "pageToken", newJString(pageToken))
  add(query_594209, "alt", newJString(alt))
  add(query_594209, "oauth_token", newJString(oauthToken))
  add(query_594209, "callback", newJString(callback))
  add(query_594209, "access_token", newJString(accessToken))
  add(query_594209, "uploadType", newJString(uploadType))
  add(query_594209, "key", newJString(key))
  add(query_594209, "$.xgafv", newJString(Xgafv))
  add(query_594209, "pageSize", newJInt(pageSize))
  add(query_594209, "projectId", newJString(projectId))
  add(path_594208, "beaconName", newJString(beaconName))
  add(query_594209, "prettyPrint", newJBool(prettyPrint))
  result = call_594207.call(path_594208, query_594209, nil, nil, nil)

var proximitybeaconBeaconsDiagnosticsList* = Call_ProximitybeaconBeaconsDiagnosticsList_594187(
    name: "proximitybeaconBeaconsDiagnosticsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/diagnostics",
    validator: validate_ProximitybeaconBeaconsDiagnosticsList_594188, base: "/",
    url: url_ProximitybeaconBeaconsDiagnosticsList_594189, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsActivate_594210 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsActivate_594212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: ":activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsActivate_594211(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activates a beacon. A beacon that is active will return information
  ## and attachment data when queried via `beaconinfo.getforobserved`.
  ## Calling this method on an already active beacon will do nothing (but
  ## will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be activated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594213 = path.getOrDefault("beaconName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "beaconName", valid_594213
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to activate. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594214 = query.getOrDefault("upload_protocol")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "upload_protocol", valid_594214
  var valid_594215 = query.getOrDefault("fields")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "fields", valid_594215
  var valid_594216 = query.getOrDefault("quotaUser")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "quotaUser", valid_594216
  var valid_594217 = query.getOrDefault("alt")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = newJString("json"))
  if valid_594217 != nil:
    section.add "alt", valid_594217
  var valid_594218 = query.getOrDefault("oauth_token")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "oauth_token", valid_594218
  var valid_594219 = query.getOrDefault("callback")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "callback", valid_594219
  var valid_594220 = query.getOrDefault("access_token")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "access_token", valid_594220
  var valid_594221 = query.getOrDefault("uploadType")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "uploadType", valid_594221
  var valid_594222 = query.getOrDefault("key")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "key", valid_594222
  var valid_594223 = query.getOrDefault("$.xgafv")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = newJString("1"))
  if valid_594223 != nil:
    section.add "$.xgafv", valid_594223
  var valid_594224 = query.getOrDefault("projectId")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "projectId", valid_594224
  var valid_594225 = query.getOrDefault("prettyPrint")
  valid_594225 = validateParameter(valid_594225, JBool, required = false,
                                 default = newJBool(true))
  if valid_594225 != nil:
    section.add "prettyPrint", valid_594225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594226: Call_ProximitybeaconBeaconsActivate_594210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates a beacon. A beacon that is active will return information
  ## and attachment data when queried via `beaconinfo.getforobserved`.
  ## Calling this method on an already active beacon will do nothing (but
  ## will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_594226.validator(path, query, header, formData, body)
  let scheme = call_594226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594226.url(scheme.get, call_594226.host, call_594226.base,
                         call_594226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594226, url, valid)

proc call*(call_594227: Call_ProximitybeaconBeaconsActivate_594210;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsActivate
  ## Activates a beacon. A beacon that is active will return information
  ## and attachment data when queried via `beaconinfo.getforobserved`.
  ## Calling this method on an already active beacon will do nothing (but
  ## will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to activate. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon that should be activated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594228 = newJObject()
  var query_594229 = newJObject()
  add(query_594229, "upload_protocol", newJString(uploadProtocol))
  add(query_594229, "fields", newJString(fields))
  add(query_594229, "quotaUser", newJString(quotaUser))
  add(query_594229, "alt", newJString(alt))
  add(query_594229, "oauth_token", newJString(oauthToken))
  add(query_594229, "callback", newJString(callback))
  add(query_594229, "access_token", newJString(accessToken))
  add(query_594229, "uploadType", newJString(uploadType))
  add(query_594229, "key", newJString(key))
  add(query_594229, "$.xgafv", newJString(Xgafv))
  add(query_594229, "projectId", newJString(projectId))
  add(path_594228, "beaconName", newJString(beaconName))
  add(query_594229, "prettyPrint", newJBool(prettyPrint))
  result = call_594227.call(path_594228, query_594229, nil, nil, nil)

var proximitybeaconBeaconsActivate* = Call_ProximitybeaconBeaconsActivate_594210(
    name: "proximitybeaconBeaconsActivate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:activate",
    validator: validate_ProximitybeaconBeaconsActivate_594211, base: "/",
    url: url_ProximitybeaconBeaconsActivate_594212, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDeactivate_594230 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsDeactivate_594232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: ":deactivate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDeactivate_594231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deactivates a beacon. Once deactivated, the API will not return
  ## information nor attachment data for the beacon when queried via
  ## `beaconinfo.getforobserved`. Calling this method on an already inactive
  ## beacon will do nothing (but will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be deactivated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594233 = path.getOrDefault("beaconName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "beaconName", valid_594233
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to deactivate. If the project id is not
  ## specified then the project making the request is used. The project id must
  ## match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594234 = query.getOrDefault("upload_protocol")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "upload_protocol", valid_594234
  var valid_594235 = query.getOrDefault("fields")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "fields", valid_594235
  var valid_594236 = query.getOrDefault("quotaUser")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "quotaUser", valid_594236
  var valid_594237 = query.getOrDefault("alt")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = newJString("json"))
  if valid_594237 != nil:
    section.add "alt", valid_594237
  var valid_594238 = query.getOrDefault("oauth_token")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "oauth_token", valid_594238
  var valid_594239 = query.getOrDefault("callback")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "callback", valid_594239
  var valid_594240 = query.getOrDefault("access_token")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "access_token", valid_594240
  var valid_594241 = query.getOrDefault("uploadType")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "uploadType", valid_594241
  var valid_594242 = query.getOrDefault("key")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "key", valid_594242
  var valid_594243 = query.getOrDefault("$.xgafv")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = newJString("1"))
  if valid_594243 != nil:
    section.add "$.xgafv", valid_594243
  var valid_594244 = query.getOrDefault("projectId")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "projectId", valid_594244
  var valid_594245 = query.getOrDefault("prettyPrint")
  valid_594245 = validateParameter(valid_594245, JBool, required = false,
                                 default = newJBool(true))
  if valid_594245 != nil:
    section.add "prettyPrint", valid_594245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_ProximitybeaconBeaconsDeactivate_594230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deactivates a beacon. Once deactivated, the API will not return
  ## information nor attachment data for the beacon when queried via
  ## `beaconinfo.getforobserved`. Calling this method on an already inactive
  ## beacon will do nothing (but will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_ProximitybeaconBeaconsDeactivate_594230;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsDeactivate
  ## Deactivates a beacon. Once deactivated, the API will not return
  ## information nor attachment data for the beacon when queried via
  ## `beaconinfo.getforobserved`. Calling this method on an already inactive
  ## beacon will do nothing (but will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to deactivate. If the project id is not
  ## specified then the project making the request is used. The project id must
  ## match the project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon that should be deactivated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  add(query_594249, "upload_protocol", newJString(uploadProtocol))
  add(query_594249, "fields", newJString(fields))
  add(query_594249, "quotaUser", newJString(quotaUser))
  add(query_594249, "alt", newJString(alt))
  add(query_594249, "oauth_token", newJString(oauthToken))
  add(query_594249, "callback", newJString(callback))
  add(query_594249, "access_token", newJString(accessToken))
  add(query_594249, "uploadType", newJString(uploadType))
  add(query_594249, "key", newJString(key))
  add(query_594249, "$.xgafv", newJString(Xgafv))
  add(query_594249, "projectId", newJString(projectId))
  add(path_594248, "beaconName", newJString(beaconName))
  add(query_594249, "prettyPrint", newJBool(prettyPrint))
  result = call_594247.call(path_594248, query_594249, nil, nil, nil)

var proximitybeaconBeaconsDeactivate* = Call_ProximitybeaconBeaconsDeactivate_594230(
    name: "proximitybeaconBeaconsDeactivate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:deactivate",
    validator: validate_ProximitybeaconBeaconsDeactivate_594231, base: "/",
    url: url_ProximitybeaconBeaconsDeactivate_594232, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDecommission_594250 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconBeaconsDecommission_594252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: ":decommission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDecommission_594251(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Decommissions the specified beacon in the service. This beacon will no
  ## longer be returned from `beaconinfo.getforobserved`. This operation is
  ## permanent -- you will not be able to re-register a beacon with this ID
  ## again.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be decommissioned. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID of the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_594253 = path.getOrDefault("beaconName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "beaconName", valid_594253
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the beacon to decommission. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594254 = query.getOrDefault("upload_protocol")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "upload_protocol", valid_594254
  var valid_594255 = query.getOrDefault("fields")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "fields", valid_594255
  var valid_594256 = query.getOrDefault("quotaUser")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "quotaUser", valid_594256
  var valid_594257 = query.getOrDefault("alt")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = newJString("json"))
  if valid_594257 != nil:
    section.add "alt", valid_594257
  var valid_594258 = query.getOrDefault("oauth_token")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "oauth_token", valid_594258
  var valid_594259 = query.getOrDefault("callback")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "callback", valid_594259
  var valid_594260 = query.getOrDefault("access_token")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "access_token", valid_594260
  var valid_594261 = query.getOrDefault("uploadType")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "uploadType", valid_594261
  var valid_594262 = query.getOrDefault("key")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "key", valid_594262
  var valid_594263 = query.getOrDefault("$.xgafv")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = newJString("1"))
  if valid_594263 != nil:
    section.add "$.xgafv", valid_594263
  var valid_594264 = query.getOrDefault("projectId")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "projectId", valid_594264
  var valid_594265 = query.getOrDefault("prettyPrint")
  valid_594265 = validateParameter(valid_594265, JBool, required = false,
                                 default = newJBool(true))
  if valid_594265 != nil:
    section.add "prettyPrint", valid_594265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594266: Call_ProximitybeaconBeaconsDecommission_594250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decommissions the specified beacon in the service. This beacon will no
  ## longer be returned from `beaconinfo.getforobserved`. This operation is
  ## permanent -- you will not be able to re-register a beacon with this ID
  ## again.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_594266.validator(path, query, header, formData, body)
  let scheme = call_594266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594266.url(scheme.get, call_594266.host, call_594266.base,
                         call_594266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594266, url, valid)

proc call*(call_594267: Call_ProximitybeaconBeaconsDecommission_594250;
          beaconName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## proximitybeaconBeaconsDecommission
  ## Decommissions the specified beacon in the service. This beacon will no
  ## longer be returned from `beaconinfo.getforobserved`. This operation is
  ## permanent -- you will not be able to re-register a beacon with this ID
  ## again.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the beacon to decommission. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   beaconName: string (required)
  ##             : Beacon that should be decommissioned. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID of the beacon's "stable" UID.
  ## Required.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594268 = newJObject()
  var query_594269 = newJObject()
  add(query_594269, "upload_protocol", newJString(uploadProtocol))
  add(query_594269, "fields", newJString(fields))
  add(query_594269, "quotaUser", newJString(quotaUser))
  add(query_594269, "alt", newJString(alt))
  add(query_594269, "oauth_token", newJString(oauthToken))
  add(query_594269, "callback", newJString(callback))
  add(query_594269, "access_token", newJString(accessToken))
  add(query_594269, "uploadType", newJString(uploadType))
  add(query_594269, "key", newJString(key))
  add(query_594269, "$.xgafv", newJString(Xgafv))
  add(query_594269, "projectId", newJString(projectId))
  add(path_594268, "beaconName", newJString(beaconName))
  add(query_594269, "prettyPrint", newJBool(prettyPrint))
  result = call_594267.call(path_594268, query_594269, nil, nil, nil)

var proximitybeaconBeaconsDecommission* = Call_ProximitybeaconBeaconsDecommission_594250(
    name: "proximitybeaconBeaconsDecommission", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:decommission",
    validator: validate_ProximitybeaconBeaconsDecommission_594251, base: "/",
    url: url_ProximitybeaconBeaconsDecommission_594252, schemes: {Scheme.Https})
type
  Call_ProximitybeaconNamespacesUpdate_594270 = ref object of OpenApiRestCall_593408
proc url_ProximitybeaconNamespacesUpdate_594272(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconNamespacesUpdate_594271(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : Resource name of this namespace. Namespaces names have the format:
  ## <code>namespaces/<var>namespace</var></code>.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594273 = path.getOrDefault("namespaceName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "namespaceName", valid_594273
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The project id of the namespace to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594274 = query.getOrDefault("upload_protocol")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "upload_protocol", valid_594274
  var valid_594275 = query.getOrDefault("fields")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "fields", valid_594275
  var valid_594276 = query.getOrDefault("quotaUser")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "quotaUser", valid_594276
  var valid_594277 = query.getOrDefault("alt")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = newJString("json"))
  if valid_594277 != nil:
    section.add "alt", valid_594277
  var valid_594278 = query.getOrDefault("oauth_token")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "oauth_token", valid_594278
  var valid_594279 = query.getOrDefault("callback")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "callback", valid_594279
  var valid_594280 = query.getOrDefault("access_token")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "access_token", valid_594280
  var valid_594281 = query.getOrDefault("uploadType")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "uploadType", valid_594281
  var valid_594282 = query.getOrDefault("key")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "key", valid_594282
  var valid_594283 = query.getOrDefault("$.xgafv")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = newJString("1"))
  if valid_594283 != nil:
    section.add "$.xgafv", valid_594283
  var valid_594284 = query.getOrDefault("projectId")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "projectId", valid_594284
  var valid_594285 = query.getOrDefault("prettyPrint")
  valid_594285 = validateParameter(valid_594285, JBool, required = false,
                                 default = newJBool(true))
  if valid_594285 != nil:
    section.add "prettyPrint", valid_594285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594287: Call_ProximitybeaconNamespacesUpdate_594270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ## 
  let valid = call_594287.validator(path, query, header, formData, body)
  let scheme = call_594287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594287.url(scheme.get, call_594287.host, call_594287.base,
                         call_594287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594287, url, valid)

proc call*(call_594288: Call_ProximitybeaconNamespacesUpdate_594270;
          namespaceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## proximitybeaconNamespacesUpdate
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ##   namespaceName: string (required)
  ##                : Resource name of this namespace. Namespaces names have the format:
  ## <code>namespaces/<var>namespace</var></code>.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The project id of the namespace to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594289 = newJObject()
  var query_594290 = newJObject()
  var body_594291 = newJObject()
  add(path_594289, "namespaceName", newJString(namespaceName))
  add(query_594290, "upload_protocol", newJString(uploadProtocol))
  add(query_594290, "fields", newJString(fields))
  add(query_594290, "quotaUser", newJString(quotaUser))
  add(query_594290, "alt", newJString(alt))
  add(query_594290, "oauth_token", newJString(oauthToken))
  add(query_594290, "callback", newJString(callback))
  add(query_594290, "access_token", newJString(accessToken))
  add(query_594290, "uploadType", newJString(uploadType))
  add(query_594290, "key", newJString(key))
  add(query_594290, "$.xgafv", newJString(Xgafv))
  add(query_594290, "projectId", newJString(projectId))
  if body != nil:
    body_594291 = body
  add(query_594290, "prettyPrint", newJBool(prettyPrint))
  result = call_594288.call(path_594289, query_594290, nil, nil, body_594291)

var proximitybeaconNamespacesUpdate* = Call_ProximitybeaconNamespacesUpdate_594270(
    name: "proximitybeaconNamespacesUpdate", meth: HttpMethod.HttpPut,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{namespaceName}",
    validator: validate_ProximitybeaconNamespacesUpdate_594271, base: "/",
    url: url_ProximitybeaconNamespacesUpdate_594272, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
