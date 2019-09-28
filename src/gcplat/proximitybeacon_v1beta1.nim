
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProximitybeaconBeaconinfoGetforobserved_579677 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconinfoGetforobserved_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconinfoGetforobserved_579678(path: JsonNode;
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
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("quotaUser")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "quotaUser", valid_579793
  var valid_579807 = query.getOrDefault("alt")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = newJString("json"))
  if valid_579807 != nil:
    section.add "alt", valid_579807
  var valid_579808 = query.getOrDefault("oauth_token")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "oauth_token", valid_579808
  var valid_579809 = query.getOrDefault("callback")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "callback", valid_579809
  var valid_579810 = query.getOrDefault("access_token")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "access_token", valid_579810
  var valid_579811 = query.getOrDefault("uploadType")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "uploadType", valid_579811
  var valid_579812 = query.getOrDefault("key")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "key", valid_579812
  var valid_579813 = query.getOrDefault("$.xgafv")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = newJString("1"))
  if valid_579813 != nil:
    section.add "$.xgafv", valid_579813
  var valid_579814 = query.getOrDefault("prettyPrint")
  valid_579814 = validateParameter(valid_579814, JBool, required = false,
                                 default = newJBool(true))
  if valid_579814 != nil:
    section.add "prettyPrint", valid_579814
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

proc call*(call_579838: Call_ProximitybeaconBeaconinfoGetforobserved_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
  ## 
  let valid = call_579838.validator(path, query, header, formData, body)
  let scheme = call_579838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579838.url(scheme.get, call_579838.host, call_579838.base,
                         call_579838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579838, url, valid)

proc call*(call_579909: Call_ProximitybeaconBeaconinfoGetforobserved_579677;
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
  var query_579910 = newJObject()
  var body_579912 = newJObject()
  add(query_579910, "upload_protocol", newJString(uploadProtocol))
  add(query_579910, "fields", newJString(fields))
  add(query_579910, "quotaUser", newJString(quotaUser))
  add(query_579910, "alt", newJString(alt))
  add(query_579910, "oauth_token", newJString(oauthToken))
  add(query_579910, "callback", newJString(callback))
  add(query_579910, "access_token", newJString(accessToken))
  add(query_579910, "uploadType", newJString(uploadType))
  add(query_579910, "key", newJString(key))
  add(query_579910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579912 = body
  add(query_579910, "prettyPrint", newJBool(prettyPrint))
  result = call_579909.call(nil, query_579910, nil, nil, body_579912)

var proximitybeaconBeaconinfoGetforobserved* = Call_ProximitybeaconBeaconinfoGetforobserved_579677(
    name: "proximitybeaconBeaconinfoGetforobserved", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/beaconinfo:getforobserved",
    validator: validate_ProximitybeaconBeaconinfoGetforobserved_579678, base: "/",
    url: url_ProximitybeaconBeaconinfoGetforobserved_579679,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsList_579951 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsList_579953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconsList_579952(path: JsonNode; query: JsonNode;
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
  var valid_579954 = query.getOrDefault("upload_protocol")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "upload_protocol", valid_579954
  var valid_579955 = query.getOrDefault("fields")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "fields", valid_579955
  var valid_579956 = query.getOrDefault("pageToken")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "pageToken", valid_579956
  var valid_579957 = query.getOrDefault("quotaUser")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "quotaUser", valid_579957
  var valid_579958 = query.getOrDefault("alt")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("json"))
  if valid_579958 != nil:
    section.add "alt", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("callback")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "callback", valid_579960
  var valid_579961 = query.getOrDefault("access_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "access_token", valid_579961
  var valid_579962 = query.getOrDefault("uploadType")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "uploadType", valid_579962
  var valid_579963 = query.getOrDefault("q")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "q", valid_579963
  var valid_579964 = query.getOrDefault("key")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "key", valid_579964
  var valid_579965 = query.getOrDefault("$.xgafv")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("1"))
  if valid_579965 != nil:
    section.add "$.xgafv", valid_579965
  var valid_579966 = query.getOrDefault("pageSize")
  valid_579966 = validateParameter(valid_579966, JInt, required = false, default = nil)
  if valid_579966 != nil:
    section.add "pageSize", valid_579966
  var valid_579967 = query.getOrDefault("projectId")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "projectId", valid_579967
  var valid_579968 = query.getOrDefault("prettyPrint")
  valid_579968 = validateParameter(valid_579968, JBool, required = false,
                                 default = newJBool(true))
  if valid_579968 != nil:
    section.add "prettyPrint", valid_579968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579969: Call_ProximitybeaconBeaconsList_579951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_ProximitybeaconBeaconsList_579951;
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
  var query_579971 = newJObject()
  add(query_579971, "upload_protocol", newJString(uploadProtocol))
  add(query_579971, "fields", newJString(fields))
  add(query_579971, "pageToken", newJString(pageToken))
  add(query_579971, "quotaUser", newJString(quotaUser))
  add(query_579971, "alt", newJString(alt))
  add(query_579971, "oauth_token", newJString(oauthToken))
  add(query_579971, "callback", newJString(callback))
  add(query_579971, "access_token", newJString(accessToken))
  add(query_579971, "uploadType", newJString(uploadType))
  add(query_579971, "q", newJString(q))
  add(query_579971, "key", newJString(key))
  add(query_579971, "$.xgafv", newJString(Xgafv))
  add(query_579971, "pageSize", newJInt(pageSize))
  add(query_579971, "projectId", newJString(projectId))
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  result = call_579970.call(nil, query_579971, nil, nil, nil)

var proximitybeaconBeaconsList* = Call_ProximitybeaconBeaconsList_579951(
    name: "proximitybeaconBeaconsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/beacons",
    validator: validate_ProximitybeaconBeaconsList_579952, base: "/",
    url: url_ProximitybeaconBeaconsList_579953, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsRegister_579972 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsRegister_579974(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconsRegister_579973(path: JsonNode;
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
  var valid_579975 = query.getOrDefault("upload_protocol")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "upload_protocol", valid_579975
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("callback")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "callback", valid_579980
  var valid_579981 = query.getOrDefault("access_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "access_token", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("key")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "key", valid_579983
  var valid_579984 = query.getOrDefault("$.xgafv")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("1"))
  if valid_579984 != nil:
    section.add "$.xgafv", valid_579984
  var valid_579985 = query.getOrDefault("projectId")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "projectId", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
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

proc call*(call_579988: Call_ProximitybeaconBeaconsRegister_579972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_ProximitybeaconBeaconsRegister_579972;
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
  var query_579990 = newJObject()
  var body_579991 = newJObject()
  add(query_579990, "upload_protocol", newJString(uploadProtocol))
  add(query_579990, "fields", newJString(fields))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "callback", newJString(callback))
  add(query_579990, "access_token", newJString(accessToken))
  add(query_579990, "uploadType", newJString(uploadType))
  add(query_579990, "key", newJString(key))
  add(query_579990, "$.xgafv", newJString(Xgafv))
  add(query_579990, "projectId", newJString(projectId))
  if body != nil:
    body_579991 = body
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  result = call_579989.call(nil, query_579990, nil, nil, body_579991)

var proximitybeaconBeaconsRegister* = Call_ProximitybeaconBeaconsRegister_579972(
    name: "proximitybeaconBeaconsRegister", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/beacons:register",
    validator: validate_ProximitybeaconBeaconsRegister_579973, base: "/",
    url: url_ProximitybeaconBeaconsRegister_579974, schemes: {Scheme.Https})
type
  Call_ProximitybeaconGetEidparams_579992 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconGetEidparams_579994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconGetEidparams_579993(path: JsonNode; query: JsonNode;
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
  var valid_579995 = query.getOrDefault("upload_protocol")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "upload_protocol", valid_579995
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  var valid_579997 = query.getOrDefault("quotaUser")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "quotaUser", valid_579997
  var valid_579998 = query.getOrDefault("alt")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("json"))
  if valid_579998 != nil:
    section.add "alt", valid_579998
  var valid_579999 = query.getOrDefault("oauth_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "oauth_token", valid_579999
  var valid_580000 = query.getOrDefault("callback")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "callback", valid_580000
  var valid_580001 = query.getOrDefault("access_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "access_token", valid_580001
  var valid_580002 = query.getOrDefault("uploadType")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "uploadType", valid_580002
  var valid_580003 = query.getOrDefault("key")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "key", valid_580003
  var valid_580004 = query.getOrDefault("$.xgafv")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("1"))
  if valid_580004 != nil:
    section.add "$.xgafv", valid_580004
  var valid_580005 = query.getOrDefault("prettyPrint")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(true))
  if valid_580005 != nil:
    section.add "prettyPrint", valid_580005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580006: Call_ProximitybeaconGetEidparams_579992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_ProximitybeaconGetEidparams_579992;
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
  var query_580008 = newJObject()
  add(query_580008, "upload_protocol", newJString(uploadProtocol))
  add(query_580008, "fields", newJString(fields))
  add(query_580008, "quotaUser", newJString(quotaUser))
  add(query_580008, "alt", newJString(alt))
  add(query_580008, "oauth_token", newJString(oauthToken))
  add(query_580008, "callback", newJString(callback))
  add(query_580008, "access_token", newJString(accessToken))
  add(query_580008, "uploadType", newJString(uploadType))
  add(query_580008, "key", newJString(key))
  add(query_580008, "$.xgafv", newJString(Xgafv))
  add(query_580008, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(nil, query_580008, nil, nil, nil)

var proximitybeaconGetEidparams* = Call_ProximitybeaconGetEidparams_579992(
    name: "proximitybeaconGetEidparams", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/eidparams",
    validator: validate_ProximitybeaconGetEidparams_579993, base: "/",
    url: url_ProximitybeaconGetEidparams_579994, schemes: {Scheme.Https})
type
  Call_ProximitybeaconNamespacesList_580009 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconNamespacesList_580011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconNamespacesList_580010(path: JsonNode; query: JsonNode;
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
  var valid_580012 = query.getOrDefault("upload_protocol")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "upload_protocol", valid_580012
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("callback")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "callback", valid_580017
  var valid_580018 = query.getOrDefault("access_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "access_token", valid_580018
  var valid_580019 = query.getOrDefault("uploadType")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "uploadType", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("$.xgafv")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("1"))
  if valid_580021 != nil:
    section.add "$.xgafv", valid_580021
  var valid_580022 = query.getOrDefault("projectId")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "projectId", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_ProximitybeaconNamespacesList_580009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **viewer**, **Is owner** or **Can edit**
  ## permissions in the Google Developers Console project.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_ProximitybeaconNamespacesList_580009;
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
  var query_580026 = newJObject()
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "callback", newJString(callback))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "key", newJString(key))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  add(query_580026, "projectId", newJString(projectId))
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  result = call_580025.call(nil, query_580026, nil, nil, nil)

var proximitybeaconNamespacesList* = Call_ProximitybeaconNamespacesList_580009(
    name: "proximitybeaconNamespacesList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/namespaces",
    validator: validate_ProximitybeaconNamespacesList_580010, base: "/",
    url: url_ProximitybeaconNamespacesList_580011, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsDelete_580027 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsAttachmentsDelete_580029(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "attachmentName" in path, "`attachmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "attachmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsDelete_580028(path: JsonNode;
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
  var valid_580044 = path.getOrDefault("attachmentName")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "attachmentName", valid_580044
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
  var valid_580045 = query.getOrDefault("upload_protocol")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "upload_protocol", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  var valid_580048 = query.getOrDefault("alt")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("json"))
  if valid_580048 != nil:
    section.add "alt", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("callback")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "callback", valid_580050
  var valid_580051 = query.getOrDefault("access_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "access_token", valid_580051
  var valid_580052 = query.getOrDefault("uploadType")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "uploadType", valid_580052
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("$.xgafv")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("1"))
  if valid_580054 != nil:
    section.add "$.xgafv", valid_580054
  var valid_580055 = query.getOrDefault("projectId")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "projectId", valid_580055
  var valid_580056 = query.getOrDefault("prettyPrint")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(true))
  if valid_580056 != nil:
    section.add "prettyPrint", valid_580056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580057: Call_ProximitybeaconBeaconsAttachmentsDelete_580027;
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
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_ProximitybeaconBeaconsAttachmentsDelete_580027;
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
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  add(query_580060, "upload_protocol", newJString(uploadProtocol))
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(path_580059, "attachmentName", newJString(attachmentName))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "callback", newJString(callback))
  add(query_580060, "access_token", newJString(accessToken))
  add(query_580060, "uploadType", newJString(uploadType))
  add(query_580060, "key", newJString(key))
  add(query_580060, "$.xgafv", newJString(Xgafv))
  add(query_580060, "projectId", newJString(projectId))
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  result = call_580058.call(path_580059, query_580060, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsDelete* = Call_ProximitybeaconBeaconsAttachmentsDelete_580027(
    name: "proximitybeaconBeaconsAttachmentsDelete", meth: HttpMethod.HttpDelete,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{attachmentName}",
    validator: validate_ProximitybeaconBeaconsAttachmentsDelete_580028, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsDelete_580029,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsUpdate_580081 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsUpdate_580083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsUpdate_580082(path: JsonNode; query: JsonNode;
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
  var valid_580084 = path.getOrDefault("beaconName")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "beaconName", valid_580084
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
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("quotaUser")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "quotaUser", valid_580087
  var valid_580088 = query.getOrDefault("alt")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("json"))
  if valid_580088 != nil:
    section.add "alt", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("callback")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "callback", valid_580090
  var valid_580091 = query.getOrDefault("access_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "access_token", valid_580091
  var valid_580092 = query.getOrDefault("uploadType")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "uploadType", valid_580092
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("$.xgafv")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("1"))
  if valid_580094 != nil:
    section.add "$.xgafv", valid_580094
  var valid_580095 = query.getOrDefault("projectId")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "projectId", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
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

proc call*(call_580098: Call_ProximitybeaconBeaconsUpdate_580081; path: JsonNode;
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
  let valid = call_580098.validator(path, query, header, formData, body)
  let scheme = call_580098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580098.url(scheme.get, call_580098.host, call_580098.base,
                         call_580098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580098, url, valid)

proc call*(call_580099: Call_ProximitybeaconBeaconsUpdate_580081;
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
  var path_580100 = newJObject()
  var query_580101 = newJObject()
  var body_580102 = newJObject()
  add(query_580101, "upload_protocol", newJString(uploadProtocol))
  add(query_580101, "fields", newJString(fields))
  add(query_580101, "quotaUser", newJString(quotaUser))
  add(query_580101, "alt", newJString(alt))
  add(query_580101, "oauth_token", newJString(oauthToken))
  add(query_580101, "callback", newJString(callback))
  add(query_580101, "access_token", newJString(accessToken))
  add(query_580101, "uploadType", newJString(uploadType))
  add(query_580101, "key", newJString(key))
  add(query_580101, "$.xgafv", newJString(Xgafv))
  add(query_580101, "projectId", newJString(projectId))
  add(path_580100, "beaconName", newJString(beaconName))
  if body != nil:
    body_580102 = body
  add(query_580101, "prettyPrint", newJBool(prettyPrint))
  result = call_580099.call(path_580100, query_580101, nil, nil, body_580102)

var proximitybeaconBeaconsUpdate* = Call_ProximitybeaconBeaconsUpdate_580081(
    name: "proximitybeaconBeaconsUpdate", meth: HttpMethod.HttpPut,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsUpdate_580082, base: "/",
    url: url_ProximitybeaconBeaconsUpdate_580083, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsGet_580061 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsGet_580063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsGet_580062(path: JsonNode; query: JsonNode;
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
  var valid_580064 = path.getOrDefault("beaconName")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "beaconName", valid_580064
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
  var valid_580065 = query.getOrDefault("upload_protocol")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "upload_protocol", valid_580065
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("quotaUser")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "quotaUser", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("callback")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "callback", valid_580070
  var valid_580071 = query.getOrDefault("access_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "access_token", valid_580071
  var valid_580072 = query.getOrDefault("uploadType")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "uploadType", valid_580072
  var valid_580073 = query.getOrDefault("key")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "key", valid_580073
  var valid_580074 = query.getOrDefault("$.xgafv")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("1"))
  if valid_580074 != nil:
    section.add "$.xgafv", valid_580074
  var valid_580075 = query.getOrDefault("projectId")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "projectId", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580077: Call_ProximitybeaconBeaconsGet_580061; path: JsonNode;
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
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_ProximitybeaconBeaconsGet_580061; beaconName: string;
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
  var path_580079 = newJObject()
  var query_580080 = newJObject()
  add(query_580080, "upload_protocol", newJString(uploadProtocol))
  add(query_580080, "fields", newJString(fields))
  add(query_580080, "quotaUser", newJString(quotaUser))
  add(query_580080, "alt", newJString(alt))
  add(query_580080, "oauth_token", newJString(oauthToken))
  add(query_580080, "callback", newJString(callback))
  add(query_580080, "access_token", newJString(accessToken))
  add(query_580080, "uploadType", newJString(uploadType))
  add(query_580080, "key", newJString(key))
  add(query_580080, "$.xgafv", newJString(Xgafv))
  add(query_580080, "projectId", newJString(projectId))
  add(path_580079, "beaconName", newJString(beaconName))
  add(query_580080, "prettyPrint", newJBool(prettyPrint))
  result = call_580078.call(path_580079, query_580080, nil, nil, nil)

var proximitybeaconBeaconsGet* = Call_ProximitybeaconBeaconsGet_580061(
    name: "proximitybeaconBeaconsGet", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsGet_580062, base: "/",
    url: url_ProximitybeaconBeaconsGet_580063, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDelete_580103 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsDelete_580105(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDelete_580104(path: JsonNode; query: JsonNode;
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
  var valid_580106 = path.getOrDefault("beaconName")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "beaconName", valid_580106
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
  var valid_580107 = query.getOrDefault("upload_protocol")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "upload_protocol", valid_580107
  var valid_580108 = query.getOrDefault("fields")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "fields", valid_580108
  var valid_580109 = query.getOrDefault("quotaUser")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "quotaUser", valid_580109
  var valid_580110 = query.getOrDefault("alt")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = newJString("json"))
  if valid_580110 != nil:
    section.add "alt", valid_580110
  var valid_580111 = query.getOrDefault("oauth_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "oauth_token", valid_580111
  var valid_580112 = query.getOrDefault("callback")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "callback", valid_580112
  var valid_580113 = query.getOrDefault("access_token")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "access_token", valid_580113
  var valid_580114 = query.getOrDefault("uploadType")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "uploadType", valid_580114
  var valid_580115 = query.getOrDefault("key")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "key", valid_580115
  var valid_580116 = query.getOrDefault("$.xgafv")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("1"))
  if valid_580116 != nil:
    section.add "$.xgafv", valid_580116
  var valid_580117 = query.getOrDefault("projectId")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "projectId", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580119: Call_ProximitybeaconBeaconsDelete_580103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access token](https://developers.google.com/identity/protocols/OAuth2)
  ## from a signed-in user with **Is owner** or **Can edit** permissions in the
  ## Google Developers Console project.
  ## 
  let valid = call_580119.validator(path, query, header, formData, body)
  let scheme = call_580119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580119.url(scheme.get, call_580119.host, call_580119.base,
                         call_580119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580119, url, valid)

proc call*(call_580120: Call_ProximitybeaconBeaconsDelete_580103;
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
  var path_580121 = newJObject()
  var query_580122 = newJObject()
  add(query_580122, "upload_protocol", newJString(uploadProtocol))
  add(query_580122, "fields", newJString(fields))
  add(query_580122, "quotaUser", newJString(quotaUser))
  add(query_580122, "alt", newJString(alt))
  add(query_580122, "oauth_token", newJString(oauthToken))
  add(query_580122, "callback", newJString(callback))
  add(query_580122, "access_token", newJString(accessToken))
  add(query_580122, "uploadType", newJString(uploadType))
  add(query_580122, "key", newJString(key))
  add(query_580122, "$.xgafv", newJString(Xgafv))
  add(query_580122, "projectId", newJString(projectId))
  add(path_580121, "beaconName", newJString(beaconName))
  add(query_580122, "prettyPrint", newJBool(prettyPrint))
  result = call_580120.call(path_580121, query_580122, nil, nil, nil)

var proximitybeaconBeaconsDelete* = Call_ProximitybeaconBeaconsDelete_580103(
    name: "proximitybeaconBeaconsDelete", meth: HttpMethod.HttpDelete,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsDelete_580104, base: "/",
    url: url_ProximitybeaconBeaconsDelete_580105, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsCreate_580144 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsAttachmentsCreate_580146(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ProximitybeaconBeaconsAttachmentsCreate_580145(path: JsonNode;
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
  var valid_580147 = path.getOrDefault("beaconName")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "beaconName", valid_580147
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
  var valid_580148 = query.getOrDefault("upload_protocol")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "upload_protocol", valid_580148
  var valid_580149 = query.getOrDefault("fields")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "fields", valid_580149
  var valid_580150 = query.getOrDefault("quotaUser")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "quotaUser", valid_580150
  var valid_580151 = query.getOrDefault("alt")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = newJString("json"))
  if valid_580151 != nil:
    section.add "alt", valid_580151
  var valid_580152 = query.getOrDefault("oauth_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "oauth_token", valid_580152
  var valid_580153 = query.getOrDefault("callback")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "callback", valid_580153
  var valid_580154 = query.getOrDefault("access_token")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "access_token", valid_580154
  var valid_580155 = query.getOrDefault("uploadType")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "uploadType", valid_580155
  var valid_580156 = query.getOrDefault("key")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "key", valid_580156
  var valid_580157 = query.getOrDefault("$.xgafv")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("1"))
  if valid_580157 != nil:
    section.add "$.xgafv", valid_580157
  var valid_580158 = query.getOrDefault("projectId")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "projectId", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
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

proc call*(call_580161: Call_ProximitybeaconBeaconsAttachmentsCreate_580144;
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
  let valid = call_580161.validator(path, query, header, formData, body)
  let scheme = call_580161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580161.url(scheme.get, call_580161.host, call_580161.base,
                         call_580161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580161, url, valid)

proc call*(call_580162: Call_ProximitybeaconBeaconsAttachmentsCreate_580144;
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
  var path_580163 = newJObject()
  var query_580164 = newJObject()
  var body_580165 = newJObject()
  add(query_580164, "upload_protocol", newJString(uploadProtocol))
  add(query_580164, "fields", newJString(fields))
  add(query_580164, "quotaUser", newJString(quotaUser))
  add(query_580164, "alt", newJString(alt))
  add(query_580164, "oauth_token", newJString(oauthToken))
  add(query_580164, "callback", newJString(callback))
  add(query_580164, "access_token", newJString(accessToken))
  add(query_580164, "uploadType", newJString(uploadType))
  add(query_580164, "key", newJString(key))
  add(query_580164, "$.xgafv", newJString(Xgafv))
  add(query_580164, "projectId", newJString(projectId))
  add(path_580163, "beaconName", newJString(beaconName))
  if body != nil:
    body_580165 = body
  add(query_580164, "prettyPrint", newJBool(prettyPrint))
  result = call_580162.call(path_580163, query_580164, nil, nil, body_580165)

var proximitybeaconBeaconsAttachmentsCreate* = Call_ProximitybeaconBeaconsAttachmentsCreate_580144(
    name: "proximitybeaconBeaconsAttachmentsCreate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments",
    validator: validate_ProximitybeaconBeaconsAttachmentsCreate_580145, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsCreate_580146,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsList_580123 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsAttachmentsList_580125(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ProximitybeaconBeaconsAttachmentsList_580124(path: JsonNode;
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
  var valid_580126 = path.getOrDefault("beaconName")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "beaconName", valid_580126
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
  var valid_580127 = query.getOrDefault("upload_protocol")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "upload_protocol", valid_580127
  var valid_580128 = query.getOrDefault("fields")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "fields", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("alt")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("json"))
  if valid_580130 != nil:
    section.add "alt", valid_580130
  var valid_580131 = query.getOrDefault("oauth_token")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "oauth_token", valid_580131
  var valid_580132 = query.getOrDefault("callback")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "callback", valid_580132
  var valid_580133 = query.getOrDefault("access_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "access_token", valid_580133
  var valid_580134 = query.getOrDefault("uploadType")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "uploadType", valid_580134
  var valid_580135 = query.getOrDefault("key")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "key", valid_580135
  var valid_580136 = query.getOrDefault("$.xgafv")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("1"))
  if valid_580136 != nil:
    section.add "$.xgafv", valid_580136
  var valid_580137 = query.getOrDefault("projectId")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "projectId", valid_580137
  var valid_580138 = query.getOrDefault("prettyPrint")
  valid_580138 = validateParameter(valid_580138, JBool, required = false,
                                 default = newJBool(true))
  if valid_580138 != nil:
    section.add "prettyPrint", valid_580138
  var valid_580139 = query.getOrDefault("namespacedType")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "namespacedType", valid_580139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580140: Call_ProximitybeaconBeaconsAttachmentsList_580123;
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
  let valid = call_580140.validator(path, query, header, formData, body)
  let scheme = call_580140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580140.url(scheme.get, call_580140.host, call_580140.base,
                         call_580140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580140, url, valid)

proc call*(call_580141: Call_ProximitybeaconBeaconsAttachmentsList_580123;
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
  var path_580142 = newJObject()
  var query_580143 = newJObject()
  add(query_580143, "upload_protocol", newJString(uploadProtocol))
  add(query_580143, "fields", newJString(fields))
  add(query_580143, "quotaUser", newJString(quotaUser))
  add(query_580143, "alt", newJString(alt))
  add(query_580143, "oauth_token", newJString(oauthToken))
  add(query_580143, "callback", newJString(callback))
  add(query_580143, "access_token", newJString(accessToken))
  add(query_580143, "uploadType", newJString(uploadType))
  add(query_580143, "key", newJString(key))
  add(query_580143, "$.xgafv", newJString(Xgafv))
  add(query_580143, "projectId", newJString(projectId))
  add(path_580142, "beaconName", newJString(beaconName))
  add(query_580143, "prettyPrint", newJBool(prettyPrint))
  add(query_580143, "namespacedType", newJString(namespacedType))
  result = call_580141.call(path_580142, query_580143, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsList* = Call_ProximitybeaconBeaconsAttachmentsList_580123(
    name: "proximitybeaconBeaconsAttachmentsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments",
    validator: validate_ProximitybeaconBeaconsAttachmentsList_580124, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsList_580125, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsBatchDelete_580166 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsAttachmentsBatchDelete_580168(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ProximitybeaconBeaconsAttachmentsBatchDelete_580167(path: JsonNode;
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
  var valid_580169 = path.getOrDefault("beaconName")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "beaconName", valid_580169
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
  var valid_580170 = query.getOrDefault("upload_protocol")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "upload_protocol", valid_580170
  var valid_580171 = query.getOrDefault("fields")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "fields", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("alt")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("json"))
  if valid_580173 != nil:
    section.add "alt", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("callback")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "callback", valid_580175
  var valid_580176 = query.getOrDefault("access_token")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "access_token", valid_580176
  var valid_580177 = query.getOrDefault("uploadType")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "uploadType", valid_580177
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("$.xgafv")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("1"))
  if valid_580179 != nil:
    section.add "$.xgafv", valid_580179
  var valid_580180 = query.getOrDefault("projectId")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "projectId", valid_580180
  var valid_580181 = query.getOrDefault("prettyPrint")
  valid_580181 = validateParameter(valid_580181, JBool, required = false,
                                 default = newJBool(true))
  if valid_580181 != nil:
    section.add "prettyPrint", valid_580181
  var valid_580182 = query.getOrDefault("namespacedType")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "namespacedType", valid_580182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580183: Call_ProximitybeaconBeaconsAttachmentsBatchDelete_580166;
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
  let valid = call_580183.validator(path, query, header, formData, body)
  let scheme = call_580183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580183.url(scheme.get, call_580183.host, call_580183.base,
                         call_580183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580183, url, valid)

proc call*(call_580184: Call_ProximitybeaconBeaconsAttachmentsBatchDelete_580166;
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
  var path_580185 = newJObject()
  var query_580186 = newJObject()
  add(query_580186, "upload_protocol", newJString(uploadProtocol))
  add(query_580186, "fields", newJString(fields))
  add(query_580186, "quotaUser", newJString(quotaUser))
  add(query_580186, "alt", newJString(alt))
  add(query_580186, "oauth_token", newJString(oauthToken))
  add(query_580186, "callback", newJString(callback))
  add(query_580186, "access_token", newJString(accessToken))
  add(query_580186, "uploadType", newJString(uploadType))
  add(query_580186, "key", newJString(key))
  add(query_580186, "$.xgafv", newJString(Xgafv))
  add(query_580186, "projectId", newJString(projectId))
  add(path_580185, "beaconName", newJString(beaconName))
  add(query_580186, "prettyPrint", newJBool(prettyPrint))
  add(query_580186, "namespacedType", newJString(namespacedType))
  result = call_580184.call(path_580185, query_580186, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsBatchDelete* = Call_ProximitybeaconBeaconsAttachmentsBatchDelete_580166(
    name: "proximitybeaconBeaconsAttachmentsBatchDelete",
    meth: HttpMethod.HttpPost, host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments:batchDelete",
    validator: validate_ProximitybeaconBeaconsAttachmentsBatchDelete_580167,
    base: "/", url: url_ProximitybeaconBeaconsAttachmentsBatchDelete_580168,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDiagnosticsList_580187 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsDiagnosticsList_580189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ProximitybeaconBeaconsDiagnosticsList_580188(path: JsonNode;
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
  var valid_580190 = path.getOrDefault("beaconName")
  valid_580190 = validateParameter(valid_580190, JString, required = true,
                                 default = nil)
  if valid_580190 != nil:
    section.add "beaconName", valid_580190
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
  var valid_580191 = query.getOrDefault("upload_protocol")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "upload_protocol", valid_580191
  var valid_580192 = query.getOrDefault("fields")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "fields", valid_580192
  var valid_580193 = query.getOrDefault("alertFilter")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("ALERT_UNSPECIFIED"))
  if valid_580193 != nil:
    section.add "alertFilter", valid_580193
  var valid_580194 = query.getOrDefault("quotaUser")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "quotaUser", valid_580194
  var valid_580195 = query.getOrDefault("pageToken")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "pageToken", valid_580195
  var valid_580196 = query.getOrDefault("alt")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = newJString("json"))
  if valid_580196 != nil:
    section.add "alt", valid_580196
  var valid_580197 = query.getOrDefault("oauth_token")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "oauth_token", valid_580197
  var valid_580198 = query.getOrDefault("callback")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "callback", valid_580198
  var valid_580199 = query.getOrDefault("access_token")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "access_token", valid_580199
  var valid_580200 = query.getOrDefault("uploadType")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "uploadType", valid_580200
  var valid_580201 = query.getOrDefault("key")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "key", valid_580201
  var valid_580202 = query.getOrDefault("$.xgafv")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("1"))
  if valid_580202 != nil:
    section.add "$.xgafv", valid_580202
  var valid_580203 = query.getOrDefault("pageSize")
  valid_580203 = validateParameter(valid_580203, JInt, required = false, default = nil)
  if valid_580203 != nil:
    section.add "pageSize", valid_580203
  var valid_580204 = query.getOrDefault("projectId")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "projectId", valid_580204
  var valid_580205 = query.getOrDefault("prettyPrint")
  valid_580205 = validateParameter(valid_580205, JBool, required = false,
                                 default = newJBool(true))
  if valid_580205 != nil:
    section.add "prettyPrint", valid_580205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580206: Call_ProximitybeaconBeaconsDiagnosticsList_580187;
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
  let valid = call_580206.validator(path, query, header, formData, body)
  let scheme = call_580206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580206.url(scheme.get, call_580206.host, call_580206.base,
                         call_580206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580206, url, valid)

proc call*(call_580207: Call_ProximitybeaconBeaconsDiagnosticsList_580187;
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
  var path_580208 = newJObject()
  var query_580209 = newJObject()
  add(query_580209, "upload_protocol", newJString(uploadProtocol))
  add(query_580209, "fields", newJString(fields))
  add(query_580209, "alertFilter", newJString(alertFilter))
  add(query_580209, "quotaUser", newJString(quotaUser))
  add(query_580209, "pageToken", newJString(pageToken))
  add(query_580209, "alt", newJString(alt))
  add(query_580209, "oauth_token", newJString(oauthToken))
  add(query_580209, "callback", newJString(callback))
  add(query_580209, "access_token", newJString(accessToken))
  add(query_580209, "uploadType", newJString(uploadType))
  add(query_580209, "key", newJString(key))
  add(query_580209, "$.xgafv", newJString(Xgafv))
  add(query_580209, "pageSize", newJInt(pageSize))
  add(query_580209, "projectId", newJString(projectId))
  add(path_580208, "beaconName", newJString(beaconName))
  add(query_580209, "prettyPrint", newJBool(prettyPrint))
  result = call_580207.call(path_580208, query_580209, nil, nil, nil)

var proximitybeaconBeaconsDiagnosticsList* = Call_ProximitybeaconBeaconsDiagnosticsList_580187(
    name: "proximitybeaconBeaconsDiagnosticsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/diagnostics",
    validator: validate_ProximitybeaconBeaconsDiagnosticsList_580188, base: "/",
    url: url_ProximitybeaconBeaconsDiagnosticsList_580189, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsActivate_580210 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsActivate_580212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ProximitybeaconBeaconsActivate_580211(path: JsonNode;
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
  var valid_580213 = path.getOrDefault("beaconName")
  valid_580213 = validateParameter(valid_580213, JString, required = true,
                                 default = nil)
  if valid_580213 != nil:
    section.add "beaconName", valid_580213
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
  var valid_580214 = query.getOrDefault("upload_protocol")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "upload_protocol", valid_580214
  var valid_580215 = query.getOrDefault("fields")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "fields", valid_580215
  var valid_580216 = query.getOrDefault("quotaUser")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "quotaUser", valid_580216
  var valid_580217 = query.getOrDefault("alt")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("json"))
  if valid_580217 != nil:
    section.add "alt", valid_580217
  var valid_580218 = query.getOrDefault("oauth_token")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "oauth_token", valid_580218
  var valid_580219 = query.getOrDefault("callback")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "callback", valid_580219
  var valid_580220 = query.getOrDefault("access_token")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "access_token", valid_580220
  var valid_580221 = query.getOrDefault("uploadType")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "uploadType", valid_580221
  var valid_580222 = query.getOrDefault("key")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "key", valid_580222
  var valid_580223 = query.getOrDefault("$.xgafv")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("1"))
  if valid_580223 != nil:
    section.add "$.xgafv", valid_580223
  var valid_580224 = query.getOrDefault("projectId")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "projectId", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580226: Call_ProximitybeaconBeaconsActivate_580210; path: JsonNode;
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
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_ProximitybeaconBeaconsActivate_580210;
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
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  add(query_580229, "upload_protocol", newJString(uploadProtocol))
  add(query_580229, "fields", newJString(fields))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "callback", newJString(callback))
  add(query_580229, "access_token", newJString(accessToken))
  add(query_580229, "uploadType", newJString(uploadType))
  add(query_580229, "key", newJString(key))
  add(query_580229, "$.xgafv", newJString(Xgafv))
  add(query_580229, "projectId", newJString(projectId))
  add(path_580228, "beaconName", newJString(beaconName))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  result = call_580227.call(path_580228, query_580229, nil, nil, nil)

var proximitybeaconBeaconsActivate* = Call_ProximitybeaconBeaconsActivate_580210(
    name: "proximitybeaconBeaconsActivate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:activate",
    validator: validate_ProximitybeaconBeaconsActivate_580211, base: "/",
    url: url_ProximitybeaconBeaconsActivate_580212, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDeactivate_580230 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsDeactivate_580232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ProximitybeaconBeaconsDeactivate_580231(path: JsonNode;
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
  var valid_580233 = path.getOrDefault("beaconName")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "beaconName", valid_580233
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
  var valid_580234 = query.getOrDefault("upload_protocol")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "upload_protocol", valid_580234
  var valid_580235 = query.getOrDefault("fields")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "fields", valid_580235
  var valid_580236 = query.getOrDefault("quotaUser")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "quotaUser", valid_580236
  var valid_580237 = query.getOrDefault("alt")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = newJString("json"))
  if valid_580237 != nil:
    section.add "alt", valid_580237
  var valid_580238 = query.getOrDefault("oauth_token")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "oauth_token", valid_580238
  var valid_580239 = query.getOrDefault("callback")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "callback", valid_580239
  var valid_580240 = query.getOrDefault("access_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "access_token", valid_580240
  var valid_580241 = query.getOrDefault("uploadType")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "uploadType", valid_580241
  var valid_580242 = query.getOrDefault("key")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "key", valid_580242
  var valid_580243 = query.getOrDefault("$.xgafv")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = newJString("1"))
  if valid_580243 != nil:
    section.add "$.xgafv", valid_580243
  var valid_580244 = query.getOrDefault("projectId")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "projectId", valid_580244
  var valid_580245 = query.getOrDefault("prettyPrint")
  valid_580245 = validateParameter(valid_580245, JBool, required = false,
                                 default = newJBool(true))
  if valid_580245 != nil:
    section.add "prettyPrint", valid_580245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580246: Call_ProximitybeaconBeaconsDeactivate_580230;
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
  let valid = call_580246.validator(path, query, header, formData, body)
  let scheme = call_580246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580246.url(scheme.get, call_580246.host, call_580246.base,
                         call_580246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580246, url, valid)

proc call*(call_580247: Call_ProximitybeaconBeaconsDeactivate_580230;
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
  var path_580248 = newJObject()
  var query_580249 = newJObject()
  add(query_580249, "upload_protocol", newJString(uploadProtocol))
  add(query_580249, "fields", newJString(fields))
  add(query_580249, "quotaUser", newJString(quotaUser))
  add(query_580249, "alt", newJString(alt))
  add(query_580249, "oauth_token", newJString(oauthToken))
  add(query_580249, "callback", newJString(callback))
  add(query_580249, "access_token", newJString(accessToken))
  add(query_580249, "uploadType", newJString(uploadType))
  add(query_580249, "key", newJString(key))
  add(query_580249, "$.xgafv", newJString(Xgafv))
  add(query_580249, "projectId", newJString(projectId))
  add(path_580248, "beaconName", newJString(beaconName))
  add(query_580249, "prettyPrint", newJBool(prettyPrint))
  result = call_580247.call(path_580248, query_580249, nil, nil, nil)

var proximitybeaconBeaconsDeactivate* = Call_ProximitybeaconBeaconsDeactivate_580230(
    name: "proximitybeaconBeaconsDeactivate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:deactivate",
    validator: validate_ProximitybeaconBeaconsDeactivate_580231, base: "/",
    url: url_ProximitybeaconBeaconsDeactivate_580232, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDecommission_580250 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconBeaconsDecommission_580252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ProximitybeaconBeaconsDecommission_580251(path: JsonNode;
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
  var valid_580253 = path.getOrDefault("beaconName")
  valid_580253 = validateParameter(valid_580253, JString, required = true,
                                 default = nil)
  if valid_580253 != nil:
    section.add "beaconName", valid_580253
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
  var valid_580254 = query.getOrDefault("upload_protocol")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "upload_protocol", valid_580254
  var valid_580255 = query.getOrDefault("fields")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "fields", valid_580255
  var valid_580256 = query.getOrDefault("quotaUser")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "quotaUser", valid_580256
  var valid_580257 = query.getOrDefault("alt")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = newJString("json"))
  if valid_580257 != nil:
    section.add "alt", valid_580257
  var valid_580258 = query.getOrDefault("oauth_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "oauth_token", valid_580258
  var valid_580259 = query.getOrDefault("callback")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "callback", valid_580259
  var valid_580260 = query.getOrDefault("access_token")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "access_token", valid_580260
  var valid_580261 = query.getOrDefault("uploadType")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "uploadType", valid_580261
  var valid_580262 = query.getOrDefault("key")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "key", valid_580262
  var valid_580263 = query.getOrDefault("$.xgafv")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("1"))
  if valid_580263 != nil:
    section.add "$.xgafv", valid_580263
  var valid_580264 = query.getOrDefault("projectId")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "projectId", valid_580264
  var valid_580265 = query.getOrDefault("prettyPrint")
  valid_580265 = validateParameter(valid_580265, JBool, required = false,
                                 default = newJBool(true))
  if valid_580265 != nil:
    section.add "prettyPrint", valid_580265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580266: Call_ProximitybeaconBeaconsDecommission_580250;
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
  let valid = call_580266.validator(path, query, header, formData, body)
  let scheme = call_580266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580266.url(scheme.get, call_580266.host, call_580266.base,
                         call_580266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580266, url, valid)

proc call*(call_580267: Call_ProximitybeaconBeaconsDecommission_580250;
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
  var path_580268 = newJObject()
  var query_580269 = newJObject()
  add(query_580269, "upload_protocol", newJString(uploadProtocol))
  add(query_580269, "fields", newJString(fields))
  add(query_580269, "quotaUser", newJString(quotaUser))
  add(query_580269, "alt", newJString(alt))
  add(query_580269, "oauth_token", newJString(oauthToken))
  add(query_580269, "callback", newJString(callback))
  add(query_580269, "access_token", newJString(accessToken))
  add(query_580269, "uploadType", newJString(uploadType))
  add(query_580269, "key", newJString(key))
  add(query_580269, "$.xgafv", newJString(Xgafv))
  add(query_580269, "projectId", newJString(projectId))
  add(path_580268, "beaconName", newJString(beaconName))
  add(query_580269, "prettyPrint", newJBool(prettyPrint))
  result = call_580267.call(path_580268, query_580269, nil, nil, nil)

var proximitybeaconBeaconsDecommission* = Call_ProximitybeaconBeaconsDecommission_580250(
    name: "proximitybeaconBeaconsDecommission", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:decommission",
    validator: validate_ProximitybeaconBeaconsDecommission_580251, base: "/",
    url: url_ProximitybeaconBeaconsDecommission_580252, schemes: {Scheme.Https})
type
  Call_ProximitybeaconNamespacesUpdate_580270 = ref object of OpenApiRestCall_579408
proc url_ProximitybeaconNamespacesUpdate_580272(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconNamespacesUpdate_580271(path: JsonNode;
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
  var valid_580273 = path.getOrDefault("namespaceName")
  valid_580273 = validateParameter(valid_580273, JString, required = true,
                                 default = nil)
  if valid_580273 != nil:
    section.add "namespaceName", valid_580273
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
  var valid_580274 = query.getOrDefault("upload_protocol")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "upload_protocol", valid_580274
  var valid_580275 = query.getOrDefault("fields")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "fields", valid_580275
  var valid_580276 = query.getOrDefault("quotaUser")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "quotaUser", valid_580276
  var valid_580277 = query.getOrDefault("alt")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = newJString("json"))
  if valid_580277 != nil:
    section.add "alt", valid_580277
  var valid_580278 = query.getOrDefault("oauth_token")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "oauth_token", valid_580278
  var valid_580279 = query.getOrDefault("callback")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "callback", valid_580279
  var valid_580280 = query.getOrDefault("access_token")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "access_token", valid_580280
  var valid_580281 = query.getOrDefault("uploadType")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "uploadType", valid_580281
  var valid_580282 = query.getOrDefault("key")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "key", valid_580282
  var valid_580283 = query.getOrDefault("$.xgafv")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = newJString("1"))
  if valid_580283 != nil:
    section.add "$.xgafv", valid_580283
  var valid_580284 = query.getOrDefault("projectId")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "projectId", valid_580284
  var valid_580285 = query.getOrDefault("prettyPrint")
  valid_580285 = validateParameter(valid_580285, JBool, required = false,
                                 default = newJBool(true))
  if valid_580285 != nil:
    section.add "prettyPrint", valid_580285
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

proc call*(call_580287: Call_ProximitybeaconNamespacesUpdate_580270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ## 
  let valid = call_580287.validator(path, query, header, formData, body)
  let scheme = call_580287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580287.url(scheme.get, call_580287.host, call_580287.base,
                         call_580287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580287, url, valid)

proc call*(call_580288: Call_ProximitybeaconNamespacesUpdate_580270;
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
  var path_580289 = newJObject()
  var query_580290 = newJObject()
  var body_580291 = newJObject()
  add(path_580289, "namespaceName", newJString(namespaceName))
  add(query_580290, "upload_protocol", newJString(uploadProtocol))
  add(query_580290, "fields", newJString(fields))
  add(query_580290, "quotaUser", newJString(quotaUser))
  add(query_580290, "alt", newJString(alt))
  add(query_580290, "oauth_token", newJString(oauthToken))
  add(query_580290, "callback", newJString(callback))
  add(query_580290, "access_token", newJString(accessToken))
  add(query_580290, "uploadType", newJString(uploadType))
  add(query_580290, "key", newJString(key))
  add(query_580290, "$.xgafv", newJString(Xgafv))
  add(query_580290, "projectId", newJString(projectId))
  if body != nil:
    body_580291 = body
  add(query_580290, "prettyPrint", newJBool(prettyPrint))
  result = call_580288.call(path_580289, query_580290, nil, nil, body_580291)

var proximitybeaconNamespacesUpdate* = Call_ProximitybeaconNamespacesUpdate_580270(
    name: "proximitybeaconNamespacesUpdate", meth: HttpMethod.HttpPut,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{namespaceName}",
    validator: validate_ProximitybeaconNamespacesUpdate_580271, base: "/",
    url: url_ProximitybeaconNamespacesUpdate_580272, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
