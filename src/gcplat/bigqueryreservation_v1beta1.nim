
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: BigQuery Reservation
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## A service to modify your BigQuery flat-rate reservations.
## 
## https://cloud.google.com/bigquery/
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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "bigqueryreservation"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigqueryreservationProjectsLocationsReservationsGet_579635 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsReservationsGet_579637(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsGet_579636(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns information about the reservation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name of the reservation to retrieve. E.g.,
  ##    projects/myproject/locations/US/reservations/team1-prod
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579763 = path.getOrDefault("name")
  valid_579763 = validateParameter(valid_579763, JString, required = true,
                                 default = nil)
  if valid_579763 != nil:
    section.add "name", valid_579763
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("$.xgafv")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("1"))
  if valid_579780 != nil:
    section.add "$.xgafv", valid_579780
  var valid_579781 = query.getOrDefault("alt")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = newJString("json"))
  if valid_579781 != nil:
    section.add "alt", valid_579781
  var valid_579782 = query.getOrDefault("uploadType")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "uploadType", valid_579782
  var valid_579783 = query.getOrDefault("quotaUser")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "quotaUser", valid_579783
  var valid_579784 = query.getOrDefault("callback")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "callback", valid_579784
  var valid_579785 = query.getOrDefault("fields")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "fields", valid_579785
  var valid_579786 = query.getOrDefault("access_token")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "access_token", valid_579786
  var valid_579787 = query.getOrDefault("upload_protocol")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "upload_protocol", valid_579787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579810: Call_BigqueryreservationProjectsLocationsReservationsGet_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the reservation.
  ## 
  let valid = call_579810.validator(path, query, header, formData, body)
  let scheme = call_579810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579810.url(scheme.get, call_579810.host, call_579810.base,
                         call_579810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579810, url, valid)

proc call*(call_579881: Call_BigqueryreservationProjectsLocationsReservationsGet_579635;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsGet
  ## Returns information about the reservation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the reservation to retrieve. E.g.,
  ##    projects/myproject/locations/US/reservations/team1-prod
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579882 = newJObject()
  var query_579884 = newJObject()
  add(query_579884, "key", newJString(key))
  add(query_579884, "prettyPrint", newJBool(prettyPrint))
  add(query_579884, "oauth_token", newJString(oauthToken))
  add(query_579884, "$.xgafv", newJString(Xgafv))
  add(query_579884, "alt", newJString(alt))
  add(query_579884, "uploadType", newJString(uploadType))
  add(query_579884, "quotaUser", newJString(quotaUser))
  add(path_579882, "name", newJString(name))
  add(query_579884, "callback", newJString(callback))
  add(query_579884, "fields", newJString(fields))
  add(query_579884, "access_token", newJString(accessToken))
  add(query_579884, "upload_protocol", newJString(uploadProtocol))
  result = call_579881.call(path_579882, query_579884, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsGet* = Call_BigqueryreservationProjectsLocationsReservationsGet_579635(
    name: "bigqueryreservationProjectsLocationsReservationsGet",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_BigqueryreservationProjectsLocationsReservationsGet_579636,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsGet_579637,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsPatch_579942 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsReservationsPatch_579944(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsPatch_579943(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing reservation resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the reservation, e.g.,
  ## "projects/*/locations/*/reservations/team1-prod".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579945 = path.getOrDefault("name")
  valid_579945 = validateParameter(valid_579945, JString, required = true,
                                 default = nil)
  if valid_579945 != nil:
    section.add "name", valid_579945
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579946 = query.getOrDefault("key")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "key", valid_579946
  var valid_579947 = query.getOrDefault("prettyPrint")
  valid_579947 = validateParameter(valid_579947, JBool, required = false,
                                 default = newJBool(true))
  if valid_579947 != nil:
    section.add "prettyPrint", valid_579947
  var valid_579948 = query.getOrDefault("oauth_token")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "oauth_token", valid_579948
  var valid_579949 = query.getOrDefault("$.xgafv")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = newJString("1"))
  if valid_579949 != nil:
    section.add "$.xgafv", valid_579949
  var valid_579950 = query.getOrDefault("alt")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = newJString("json"))
  if valid_579950 != nil:
    section.add "alt", valid_579950
  var valid_579951 = query.getOrDefault("uploadType")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "uploadType", valid_579951
  var valid_579952 = query.getOrDefault("quotaUser")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "quotaUser", valid_579952
  var valid_579953 = query.getOrDefault("updateMask")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "updateMask", valid_579953
  var valid_579954 = query.getOrDefault("callback")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "callback", valid_579954
  var valid_579955 = query.getOrDefault("fields")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "fields", valid_579955
  var valid_579956 = query.getOrDefault("access_token")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "access_token", valid_579956
  var valid_579957 = query.getOrDefault("upload_protocol")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "upload_protocol", valid_579957
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

proc call*(call_579959: Call_BigqueryreservationProjectsLocationsReservationsPatch_579942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing reservation resource.
  ## 
  let valid = call_579959.validator(path, query, header, formData, body)
  let scheme = call_579959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579959.url(scheme.get, call_579959.host, call_579959.base,
                         call_579959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579959, url, valid)

proc call*(call_579960: Call_BigqueryreservationProjectsLocationsReservationsPatch_579942;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsPatch
  ## Updates an existing reservation resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the reservation, e.g.,
  ## "projects/*/locations/*/reservations/team1-prod".
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579961 = newJObject()
  var query_579962 = newJObject()
  var body_579963 = newJObject()
  add(query_579962, "key", newJString(key))
  add(query_579962, "prettyPrint", newJBool(prettyPrint))
  add(query_579962, "oauth_token", newJString(oauthToken))
  add(query_579962, "$.xgafv", newJString(Xgafv))
  add(query_579962, "alt", newJString(alt))
  add(query_579962, "uploadType", newJString(uploadType))
  add(query_579962, "quotaUser", newJString(quotaUser))
  add(path_579961, "name", newJString(name))
  add(query_579962, "updateMask", newJString(updateMask))
  if body != nil:
    body_579963 = body
  add(query_579962, "callback", newJString(callback))
  add(query_579962, "fields", newJString(fields))
  add(query_579962, "access_token", newJString(accessToken))
  add(query_579962, "upload_protocol", newJString(uploadProtocol))
  result = call_579960.call(path_579961, query_579962, nil, nil, body_579963)

var bigqueryreservationProjectsLocationsReservationsPatch* = Call_BigqueryreservationProjectsLocationsReservationsPatch_579942(
    name: "bigqueryreservationProjectsLocationsReservationsPatch",
    meth: HttpMethod.HttpPatch, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_BigqueryreservationProjectsLocationsReservationsPatch_579943,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsPatch_579944,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_579923 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_579925(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_579924(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a assignment. No expansion will happen.
  ## E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateAssignment was invoked previously and following assignments were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then deletion of <organizationA, res1> won't affect <project1, res1>. After
  ## deletion of <organizationA, res1>, queries from project1 will still use
  ## res1, while queries from project2 will use on-demand mode.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource, e.g.:
  ##   projects/myproject/locations/US/reservations/team1-prod/assignments/123
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579926 = path.getOrDefault("name")
  valid_579926 = validateParameter(valid_579926, JString, required = true,
                                 default = nil)
  if valid_579926 != nil:
    section.add "name", valid_579926
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579927 = query.getOrDefault("key")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "key", valid_579927
  var valid_579928 = query.getOrDefault("prettyPrint")
  valid_579928 = validateParameter(valid_579928, JBool, required = false,
                                 default = newJBool(true))
  if valid_579928 != nil:
    section.add "prettyPrint", valid_579928
  var valid_579929 = query.getOrDefault("oauth_token")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "oauth_token", valid_579929
  var valid_579930 = query.getOrDefault("$.xgafv")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = newJString("1"))
  if valid_579930 != nil:
    section.add "$.xgafv", valid_579930
  var valid_579931 = query.getOrDefault("alt")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = newJString("json"))
  if valid_579931 != nil:
    section.add "alt", valid_579931
  var valid_579932 = query.getOrDefault("uploadType")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "uploadType", valid_579932
  var valid_579933 = query.getOrDefault("quotaUser")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "quotaUser", valid_579933
  var valid_579934 = query.getOrDefault("callback")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "callback", valid_579934
  var valid_579935 = query.getOrDefault("fields")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "fields", valid_579935
  var valid_579936 = query.getOrDefault("access_token")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "access_token", valid_579936
  var valid_579937 = query.getOrDefault("upload_protocol")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "upload_protocol", valid_579937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579938: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_579923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a assignment. No expansion will happen.
  ## E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateAssignment was invoked previously and following assignments were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then deletion of <organizationA, res1> won't affect <project1, res1>. After
  ## deletion of <organizationA, res1>, queries from project1 will still use
  ## res1, while queries from project2 will use on-demand mode.
  ## 
  let valid = call_579938.validator(path, query, header, formData, body)
  let scheme = call_579938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579938.url(scheme.get, call_579938.host, call_579938.base,
                         call_579938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579938, url, valid)

proc call*(call_579939: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_579923;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsAssignmentsDelete
  ## Deletes a assignment. No expansion will happen.
  ## E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateAssignment was invoked previously and following assignments were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then deletion of <organizationA, res1> won't affect <project1, res1>. After
  ## deletion of <organizationA, res1>, queries from project1 will still use
  ## res1, while queries from project2 will use on-demand mode.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the resource, e.g.:
  ##   projects/myproject/locations/US/reservations/team1-prod/assignments/123
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579940 = newJObject()
  var query_579941 = newJObject()
  add(query_579941, "key", newJString(key))
  add(query_579941, "prettyPrint", newJBool(prettyPrint))
  add(query_579941, "oauth_token", newJString(oauthToken))
  add(query_579941, "$.xgafv", newJString(Xgafv))
  add(query_579941, "alt", newJString(alt))
  add(query_579941, "uploadType", newJString(uploadType))
  add(query_579941, "quotaUser", newJString(quotaUser))
  add(path_579940, "name", newJString(name))
  add(query_579941, "callback", newJString(callback))
  add(query_579941, "fields", newJString(fields))
  add(query_579941, "access_token", newJString(accessToken))
  add(query_579941, "upload_protocol", newJString(uploadProtocol))
  result = call_579939.call(path_579940, query_579941, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsAssignmentsDelete* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_579923(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsDelete",
    meth: HttpMethod.HttpDelete, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_579924,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_579925,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsList_579964 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsList_579966(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsList_579965(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579967 = path.getOrDefault("name")
  valid_579967 = validateParameter(valid_579967, JString, required = true,
                                 default = nil)
  if valid_579967 != nil:
    section.add "name", valid_579967
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579968 = query.getOrDefault("key")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "key", valid_579968
  var valid_579969 = query.getOrDefault("prettyPrint")
  valid_579969 = validateParameter(valid_579969, JBool, required = false,
                                 default = newJBool(true))
  if valid_579969 != nil:
    section.add "prettyPrint", valid_579969
  var valid_579970 = query.getOrDefault("oauth_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "oauth_token", valid_579970
  var valid_579971 = query.getOrDefault("$.xgafv")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = newJString("1"))
  if valid_579971 != nil:
    section.add "$.xgafv", valid_579971
  var valid_579972 = query.getOrDefault("pageSize")
  valid_579972 = validateParameter(valid_579972, JInt, required = false, default = nil)
  if valid_579972 != nil:
    section.add "pageSize", valid_579972
  var valid_579973 = query.getOrDefault("alt")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("json"))
  if valid_579973 != nil:
    section.add "alt", valid_579973
  var valid_579974 = query.getOrDefault("uploadType")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "uploadType", valid_579974
  var valid_579975 = query.getOrDefault("quotaUser")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "quotaUser", valid_579975
  var valid_579976 = query.getOrDefault("filter")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "filter", valid_579976
  var valid_579977 = query.getOrDefault("pageToken")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "pageToken", valid_579977
  var valid_579978 = query.getOrDefault("callback")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "callback", valid_579978
  var valid_579979 = query.getOrDefault("fields")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "fields", valid_579979
  var valid_579980 = query.getOrDefault("access_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "access_token", valid_579980
  var valid_579981 = query.getOrDefault("upload_protocol")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "upload_protocol", valid_579981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579982: Call_BigqueryreservationProjectsLocationsList_579964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_579982.validator(path, query, header, formData, body)
  let scheme = call_579982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579982.url(scheme.get, call_579982.host, call_579982.base,
                         call_579982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579982, url, valid)

proc call*(call_579983: Call_BigqueryreservationProjectsLocationsList_579964;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579984 = newJObject()
  var query_579985 = newJObject()
  add(query_579985, "key", newJString(key))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  add(query_579985, "pageSize", newJInt(pageSize))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "uploadType", newJString(uploadType))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(path_579984, "name", newJString(name))
  add(query_579985, "filter", newJString(filter))
  add(query_579985, "pageToken", newJString(pageToken))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  result = call_579983.call(path_579984, query_579985, nil, nil, nil)

var bigqueryreservationProjectsLocationsList* = Call_BigqueryreservationProjectsLocationsList_579964(
    name: "bigqueryreservationProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}/locations",
    validator: validate_BigqueryreservationProjectsLocationsList_579965,
    base: "/", url: url_BigqueryreservationProjectsLocationsList_579966,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_579986 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_579988(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":move")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_579987(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Moves a assignment under a new reservation. Customers can do this by
  ## deleting the existing assignment followed by creating another assignment
  ## under the new reservation, but this method provides a transactional way to
  ## do so, to make sure the assignee always has an associated reservation.
  ## Without the method customers might see some queries run on-demand which
  ## might be unexpected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the assignment,
  ## e.g.:
  ##   projects/myproject/locations/US/reservations/team1-prod/assignments/123
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579989 = path.getOrDefault("name")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "name", valid_579989
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("$.xgafv")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("1"))
  if valid_579993 != nil:
    section.add "$.xgafv", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("quotaUser")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "quotaUser", valid_579996
  var valid_579997 = query.getOrDefault("callback")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "callback", valid_579997
  var valid_579998 = query.getOrDefault("fields")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "fields", valid_579998
  var valid_579999 = query.getOrDefault("access_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "access_token", valid_579999
  var valid_580000 = query.getOrDefault("upload_protocol")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "upload_protocol", valid_580000
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

proc call*(call_580002: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_579986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves a assignment under a new reservation. Customers can do this by
  ## deleting the existing assignment followed by creating another assignment
  ## under the new reservation, but this method provides a transactional way to
  ## do so, to make sure the assignee always has an associated reservation.
  ## Without the method customers might see some queries run on-demand which
  ## might be unexpected.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_579986;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsAssignmentsMove
  ## Moves a assignment under a new reservation. Customers can do this by
  ## deleting the existing assignment followed by creating another assignment
  ## under the new reservation, but this method provides a transactional way to
  ## do so, to make sure the assignee always has an associated reservation.
  ## Without the method customers might see some queries run on-demand which
  ## might be unexpected.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the assignment,
  ## e.g.:
  ##   projects/myproject/locations/US/reservations/team1-prod/assignments/123
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  var body_580006 = newJObject()
  add(query_580005, "key", newJString(key))
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(query_580005, "$.xgafv", newJString(Xgafv))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "uploadType", newJString(uploadType))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(path_580004, "name", newJString(name))
  if body != nil:
    body_580006 = body
  add(query_580005, "callback", newJString(callback))
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "access_token", newJString(accessToken))
  add(query_580005, "upload_protocol", newJString(uploadProtocol))
  result = call_580003.call(path_580004, query_580005, nil, nil, body_580006)

var bigqueryreservationProjectsLocationsReservationsAssignmentsMove* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_579986(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsMove",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}:move", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_579987,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_579988,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_580028 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_580030(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_580029(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the assignment
  ## does not match location of the reservation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name of the assignment
  ## E.g.: projects/myproject/locations/US/reservations/team1-prod
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580031 = path.getOrDefault("parent")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "parent", valid_580031
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580032 = query.getOrDefault("key")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "key", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("$.xgafv")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("1"))
  if valid_580035 != nil:
    section.add "$.xgafv", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("uploadType")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "uploadType", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("access_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "access_token", valid_580041
  var valid_580042 = query.getOrDefault("upload_protocol")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "upload_protocol", valid_580042
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

proc call*(call_580044: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the assignment
  ## does not match location of the reservation.
  ## 
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_580028;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsAssignmentsCreate
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the assignment
  ## does not match location of the reservation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name of the assignment
  ## E.g.: projects/myproject/locations/US/reservations/team1-prod
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "key", newJString(key))
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "$.xgafv", newJString(Xgafv))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "uploadType", newJString(uploadType))
  add(query_580047, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580048 = body
  add(query_580047, "callback", newJString(callback))
  add(path_580046, "parent", newJString(parent))
  add(query_580047, "fields", newJString(fields))
  add(query_580047, "access_token", newJString(accessToken))
  add(query_580047, "upload_protocol", newJString(uploadProtocol))
  result = call_580045.call(path_580046, query_580047, nil, nil, body_580048)

var bigqueryreservationProjectsLocationsReservationsAssignmentsCreate* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_580028(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/assignments", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_580029,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_580030,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_580007 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsList_580009(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsList_580008(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists assignments.
  ## Only explicitly created assignments will be returned. E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateAssignment was invoked previously and following assignments were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then this API will just return the above two assignments for reservation
  ## res1, and no expansion/merge will happen. Wildcard "-" can be used for
  ## reservations in the request. In that case all assignments belongs to the
  ## specified project and location will be listed. Note
  ## "-" cannot be used for projects nor locations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name e.g.:
  ## projects/myproject/locations/US/reservations/team1-prod
  ## Or:
  ## projects/myproject/locations/US/reservations/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580010 = path.getOrDefault("parent")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "parent", valid_580010
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580011 = query.getOrDefault("key")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "key", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("$.xgafv")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("1"))
  if valid_580014 != nil:
    section.add "$.xgafv", valid_580014
  var valid_580015 = query.getOrDefault("pageSize")
  valid_580015 = validateParameter(valid_580015, JInt, required = false, default = nil)
  if valid_580015 != nil:
    section.add "pageSize", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("uploadType")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "uploadType", valid_580017
  var valid_580018 = query.getOrDefault("quotaUser")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "quotaUser", valid_580018
  var valid_580019 = query.getOrDefault("pageToken")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "pageToken", valid_580019
  var valid_580020 = query.getOrDefault("callback")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "callback", valid_580020
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("access_token")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "access_token", valid_580022
  var valid_580023 = query.getOrDefault("upload_protocol")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "upload_protocol", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_580007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists assignments.
  ## Only explicitly created assignments will be returned. E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateAssignment was invoked previously and following assignments were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then this API will just return the above two assignments for reservation
  ## res1, and no expansion/merge will happen. Wildcard "-" can be used for
  ## reservations in the request. In that case all assignments belongs to the
  ## specified project and location will be listed. Note
  ## "-" cannot be used for projects nor locations.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_580007;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsAssignmentsList
  ## Lists assignments.
  ## Only explicitly created assignments will be returned. E.g:
  ## organizationA contains project1 and project2. Reservation res1 exists.
  ## CreateAssignment was invoked previously and following assignments were
  ## created explicitly:
  ##   <organizationA, res1>
  ##   <project1, res1>
  ## Then this API will just return the above two assignments for reservation
  ## res1, and no expansion/merge will happen. Wildcard "-" can be used for
  ## reservations in the request. In that case all assignments belongs to the
  ## specified project and location will be listed. Note
  ## "-" cannot be used for projects nor locations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name e.g.:
  ## projects/myproject/locations/US/reservations/team1-prod
  ## Or:
  ## projects/myproject/locations/US/reservations/-
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "key", newJString(key))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "$.xgafv", newJString(Xgafv))
  add(query_580027, "pageSize", newJInt(pageSize))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "uploadType", newJString(uploadType))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(query_580027, "pageToken", newJString(pageToken))
  add(query_580027, "callback", newJString(callback))
  add(path_580026, "parent", newJString(parent))
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "access_token", newJString(accessToken))
  add(query_580027, "upload_protocol", newJString(uploadProtocol))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsAssignmentsList* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_580007(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/assignments", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsList_580008,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsList_580009,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsCapacityCommitmentsCreate_580070 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsCapacityCommitmentsCreate_580072(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/capacityCommitments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsCapacityCommitmentsCreate_580071(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new capacity commitment resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the parent reservation. E.g.,
  ##    projects/myproject/locations/US
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580073 = path.getOrDefault("parent")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "parent", valid_580073
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580074 = query.getOrDefault("key")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "key", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
  var valid_580076 = query.getOrDefault("oauth_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "oauth_token", valid_580076
  var valid_580077 = query.getOrDefault("$.xgafv")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("1"))
  if valid_580077 != nil:
    section.add "$.xgafv", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("uploadType")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "uploadType", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("callback")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "callback", valid_580081
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  var valid_580083 = query.getOrDefault("access_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "access_token", valid_580083
  var valid_580084 = query.getOrDefault("upload_protocol")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "upload_protocol", valid_580084
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

proc call*(call_580086: Call_BigqueryreservationProjectsLocationsCapacityCommitmentsCreate_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new capacity commitment resource.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_BigqueryreservationProjectsLocationsCapacityCommitmentsCreate_580070;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsCapacityCommitmentsCreate
  ## Creates a new capacity commitment resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Resource name of the parent reservation. E.g.,
  ##    projects/myproject/locations/US
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(query_580089, "key", newJString(key))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "$.xgafv", newJString(Xgafv))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "uploadType", newJString(uploadType))
  add(query_580089, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580090 = body
  add(query_580089, "callback", newJString(callback))
  add(path_580088, "parent", newJString(parent))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "access_token", newJString(accessToken))
  add(query_580089, "upload_protocol", newJString(uploadProtocol))
  result = call_580087.call(path_580088, query_580089, nil, nil, body_580090)

var bigqueryreservationProjectsLocationsCapacityCommitmentsCreate* = Call_BigqueryreservationProjectsLocationsCapacityCommitmentsCreate_580070(
    name: "bigqueryreservationProjectsLocationsCapacityCommitmentsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/capacityCommitments", validator: validate_BigqueryreservationProjectsLocationsCapacityCommitmentsCreate_580071,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsCapacityCommitmentsCreate_580072,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_580049 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsCapacityCommitmentsList_580051(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/capacityCommitments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsCapacityCommitmentsList_580050(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the capacity commitments for the admin project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the parent reservation. E.g.,
  ##    projects/myproject/locations/US
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580052 = path.getOrDefault("parent")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "parent", valid_580052
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("$.xgafv")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("1"))
  if valid_580056 != nil:
    section.add "$.xgafv", valid_580056
  var valid_580057 = query.getOrDefault("pageSize")
  valid_580057 = validateParameter(valid_580057, JInt, required = false, default = nil)
  if valid_580057 != nil:
    section.add "pageSize", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("uploadType")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "uploadType", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("pageToken")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "pageToken", valid_580061
  var valid_580062 = query.getOrDefault("callback")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "callback", valid_580062
  var valid_580063 = query.getOrDefault("fields")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "fields", valid_580063
  var valid_580064 = query.getOrDefault("access_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "access_token", valid_580064
  var valid_580065 = query.getOrDefault("upload_protocol")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "upload_protocol", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the capacity commitments for the admin project.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_580049;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsCapacityCommitmentsList
  ## Lists all the capacity commitments for the admin project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Resource name of the parent reservation. E.g.,
  ##    projects/myproject/locations/US
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  add(query_580069, "key", newJString(key))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(query_580069, "pageSize", newJInt(pageSize))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(query_580069, "pageToken", newJString(pageToken))
  add(query_580069, "callback", newJString(callback))
  add(path_580068, "parent", newJString(parent))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  result = call_580067.call(path_580068, query_580069, nil, nil, nil)

var bigqueryreservationProjectsLocationsCapacityCommitmentsList* = Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_580049(
    name: "bigqueryreservationProjectsLocationsCapacityCommitmentsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/capacityCommitments", validator: validate_BigqueryreservationProjectsLocationsCapacityCommitmentsList_580050,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsCapacityCommitmentsList_580051,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsCreate_580113 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsReservationsCreate_580115(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/reservations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsCreate_580114(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new reservation resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Project, location. E.g.,
  ##    projects/myproject/locations/US
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580116 = path.getOrDefault("parent")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "parent", valid_580116
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   reservationId: JString
  ##                : The reservation ID. This field must only contain lower case alphanumeric
  ## characters or dash.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580117 = query.getOrDefault("key")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "key", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  var valid_580119 = query.getOrDefault("oauth_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "oauth_token", valid_580119
  var valid_580120 = query.getOrDefault("$.xgafv")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("1"))
  if valid_580120 != nil:
    section.add "$.xgafv", valid_580120
  var valid_580121 = query.getOrDefault("reservationId")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "reservationId", valid_580121
  var valid_580122 = query.getOrDefault("alt")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("json"))
  if valid_580122 != nil:
    section.add "alt", valid_580122
  var valid_580123 = query.getOrDefault("uploadType")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "uploadType", valid_580123
  var valid_580124 = query.getOrDefault("quotaUser")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "quotaUser", valid_580124
  var valid_580125 = query.getOrDefault("callback")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "callback", valid_580125
  var valid_580126 = query.getOrDefault("fields")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "fields", valid_580126
  var valid_580127 = query.getOrDefault("access_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "access_token", valid_580127
  var valid_580128 = query.getOrDefault("upload_protocol")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "upload_protocol", valid_580128
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

proc call*(call_580130: Call_BigqueryreservationProjectsLocationsReservationsCreate_580113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new reservation resource.
  ## 
  let valid = call_580130.validator(path, query, header, formData, body)
  let scheme = call_580130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580130.url(scheme.get, call_580130.host, call_580130.base,
                         call_580130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580130, url, valid)

proc call*(call_580131: Call_BigqueryreservationProjectsLocationsReservationsCreate_580113;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; reservationId: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsCreate
  ## Creates a new reservation resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   reservationId: string
  ##                : The reservation ID. This field must only contain lower case alphanumeric
  ## characters or dash.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Project, location. E.g.,
  ##    projects/myproject/locations/US
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580132 = newJObject()
  var query_580133 = newJObject()
  var body_580134 = newJObject()
  add(query_580133, "key", newJString(key))
  add(query_580133, "prettyPrint", newJBool(prettyPrint))
  add(query_580133, "oauth_token", newJString(oauthToken))
  add(query_580133, "$.xgafv", newJString(Xgafv))
  add(query_580133, "reservationId", newJString(reservationId))
  add(query_580133, "alt", newJString(alt))
  add(query_580133, "uploadType", newJString(uploadType))
  add(query_580133, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580134 = body
  add(query_580133, "callback", newJString(callback))
  add(path_580132, "parent", newJString(parent))
  add(query_580133, "fields", newJString(fields))
  add(query_580133, "access_token", newJString(accessToken))
  add(query_580133, "upload_protocol", newJString(uploadProtocol))
  result = call_580131.call(path_580132, query_580133, nil, nil, body_580134)

var bigqueryreservationProjectsLocationsReservationsCreate* = Call_BigqueryreservationProjectsLocationsReservationsCreate_580113(
    name: "bigqueryreservationProjectsLocationsReservationsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsCreate_580114,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsCreate_580115,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsList_580091 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsReservationsList_580093(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/reservations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsList_580092(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the reservations for the project in the specified location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name containing project and location, e.g.:
  ##   "projects/myproject/locations/US"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580094 = path.getOrDefault("parent")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "parent", valid_580094
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Can be used to filter out reservations based on names, capacity, etc, e.g.:
  ## filter="reservation.slot_capacity > 200"
  ## filter="reservation.name = \"*dev/*\""
  ## Advanced filtering syntax can be
  ## [here](https://cloud.google.com/logging/docs/view/advanced-filters).
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580095 = query.getOrDefault("key")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "key", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("$.xgafv")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("1"))
  if valid_580098 != nil:
    section.add "$.xgafv", valid_580098
  var valid_580099 = query.getOrDefault("pageSize")
  valid_580099 = validateParameter(valid_580099, JInt, required = false, default = nil)
  if valid_580099 != nil:
    section.add "pageSize", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("uploadType")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "uploadType", valid_580101
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("filter")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "filter", valid_580103
  var valid_580104 = query.getOrDefault("pageToken")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "pageToken", valid_580104
  var valid_580105 = query.getOrDefault("callback")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "callback", valid_580105
  var valid_580106 = query.getOrDefault("fields")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "fields", valid_580106
  var valid_580107 = query.getOrDefault("access_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "access_token", valid_580107
  var valid_580108 = query.getOrDefault("upload_protocol")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "upload_protocol", valid_580108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580109: Call_BigqueryreservationProjectsLocationsReservationsList_580091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the reservations for the project in the specified location.
  ## 
  let valid = call_580109.validator(path, query, header, formData, body)
  let scheme = call_580109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580109.url(scheme.get, call_580109.host, call_580109.base,
                         call_580109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580109, url, valid)

proc call*(call_580110: Call_BigqueryreservationProjectsLocationsReservationsList_580091;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsList
  ## Lists all the reservations for the project in the specified location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Can be used to filter out reservations based on names, capacity, etc, e.g.:
  ## filter="reservation.slot_capacity > 200"
  ## filter="reservation.name = \"*dev/*\""
  ## Advanced filtering syntax can be
  ## [here](https://cloud.google.com/logging/docs/view/advanced-filters).
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name containing project and location, e.g.:
  ##   "projects/myproject/locations/US"
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580111 = newJObject()
  var query_580112 = newJObject()
  add(query_580112, "key", newJString(key))
  add(query_580112, "prettyPrint", newJBool(prettyPrint))
  add(query_580112, "oauth_token", newJString(oauthToken))
  add(query_580112, "$.xgafv", newJString(Xgafv))
  add(query_580112, "pageSize", newJInt(pageSize))
  add(query_580112, "alt", newJString(alt))
  add(query_580112, "uploadType", newJString(uploadType))
  add(query_580112, "quotaUser", newJString(quotaUser))
  add(query_580112, "filter", newJString(filter))
  add(query_580112, "pageToken", newJString(pageToken))
  add(query_580112, "callback", newJString(callback))
  add(path_580111, "parent", newJString(parent))
  add(query_580112, "fields", newJString(fields))
  add(query_580112, "access_token", newJString(accessToken))
  add(query_580112, "upload_protocol", newJString(uploadProtocol))
  result = call_580110.call(path_580111, query_580112, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsList* = Call_BigqueryreservationProjectsLocationsReservationsList_580091(
    name: "bigqueryreservationProjectsLocationsReservationsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsList_580092,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsList_580093,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsSearchAssignments_580135 = ref object of OpenApiRestCall_579364
proc url_BigqueryreservationProjectsLocationsSearchAssignments_580137(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":searchAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsSearchAssignments_580136(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Looks up assignments for a specified resource for a particular region.
  ## If the request is about a project:
  ##   1) Assignments created on the project will be returned if they exist.
  ##   2) Otherwise assignments created on the closest ancestor will be
  ##   returned. 3) Assignments for different JobTypes will all be returned.
  ## Same logic applies if the request is about a folder.
  ## If the request is about an organization, then assignments created on the
  ## organization will be returned (organization doesn't have ancestors).
  ## Comparing to ListAssignments, there are some behavior
  ## differences:
  ##   1) permission on the assignee will be verified in this API.
  ##   2) Hierarchy lookup (project->folder->organization) happens in this API.
  ##   3) Parent here is projects/*/locations/*, instead of
  ##   projects/*/locations/*reservations/*.
  ## Note "-" cannot be used for projects
  ## nor locations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the admin project(containing project and location),
  ## e.g.:
  ##   "projects/myproject/locations/US".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580138 = path.getOrDefault("parent")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "parent", valid_580138
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   query: JString
  ##        : Please specify resource name as assignee in the query.
  ## e.g., "assignee=projects/myproject"
  ##       "assignee=folders/123"
  ##       "assignee=organizations/456"
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("$.xgafv")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("1"))
  if valid_580142 != nil:
    section.add "$.xgafv", valid_580142
  var valid_580143 = query.getOrDefault("pageSize")
  valid_580143 = validateParameter(valid_580143, JInt, required = false, default = nil)
  if valid_580143 != nil:
    section.add "pageSize", valid_580143
  var valid_580144 = query.getOrDefault("alt")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = newJString("json"))
  if valid_580144 != nil:
    section.add "alt", valid_580144
  var valid_580145 = query.getOrDefault("uploadType")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "uploadType", valid_580145
  var valid_580146 = query.getOrDefault("quotaUser")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "quotaUser", valid_580146
  var valid_580147 = query.getOrDefault("pageToken")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "pageToken", valid_580147
  var valid_580148 = query.getOrDefault("query")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "query", valid_580148
  var valid_580149 = query.getOrDefault("callback")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "callback", valid_580149
  var valid_580150 = query.getOrDefault("fields")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "fields", valid_580150
  var valid_580151 = query.getOrDefault("access_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "access_token", valid_580151
  var valid_580152 = query.getOrDefault("upload_protocol")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "upload_protocol", valid_580152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580153: Call_BigqueryreservationProjectsLocationsSearchAssignments_580135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up assignments for a specified resource for a particular region.
  ## If the request is about a project:
  ##   1) Assignments created on the project will be returned if they exist.
  ##   2) Otherwise assignments created on the closest ancestor will be
  ##   returned. 3) Assignments for different JobTypes will all be returned.
  ## Same logic applies if the request is about a folder.
  ## If the request is about an organization, then assignments created on the
  ## organization will be returned (organization doesn't have ancestors).
  ## Comparing to ListAssignments, there are some behavior
  ## differences:
  ##   1) permission on the assignee will be verified in this API.
  ##   2) Hierarchy lookup (project->folder->organization) happens in this API.
  ##   3) Parent here is projects/*/locations/*, instead of
  ##   projects/*/locations/*reservations/*.
  ## Note "-" cannot be used for projects
  ## nor locations.
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_BigqueryreservationProjectsLocationsSearchAssignments_580135;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsSearchAssignments
  ## Looks up assignments for a specified resource for a particular region.
  ## If the request is about a project:
  ##   1) Assignments created on the project will be returned if they exist.
  ##   2) Otherwise assignments created on the closest ancestor will be
  ##   returned. 3) Assignments for different JobTypes will all be returned.
  ## Same logic applies if the request is about a folder.
  ## If the request is about an organization, then assignments created on the
  ## organization will be returned (organization doesn't have ancestors).
  ## Comparing to ListAssignments, there are some behavior
  ## differences:
  ##   1) permission on the assignee will be verified in this API.
  ##   2) Hierarchy lookup (project->folder->organization) happens in this API.
  ##   3) Parent here is projects/*/locations/*, instead of
  ##   projects/*/locations/*reservations/*.
  ## Note "-" cannot be used for projects
  ## nor locations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   query: string
  ##        : Please specify resource name as assignee in the query.
  ## e.g., "assignee=projects/myproject"
  ##       "assignee=folders/123"
  ##       "assignee=organizations/456"
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The resource name of the admin project(containing project and location),
  ## e.g.:
  ##   "projects/myproject/locations/US".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  add(query_580156, "key", newJString(key))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "$.xgafv", newJString(Xgafv))
  add(query_580156, "pageSize", newJInt(pageSize))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "uploadType", newJString(uploadType))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "pageToken", newJString(pageToken))
  add(query_580156, "query", newJString(query))
  add(query_580156, "callback", newJString(callback))
  add(path_580155, "parent", newJString(parent))
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "access_token", newJString(accessToken))
  add(query_580156, "upload_protocol", newJString(uploadProtocol))
  result = call_580154.call(path_580155, query_580156, nil, nil, nil)

var bigqueryreservationProjectsLocationsSearchAssignments* = Call_BigqueryreservationProjectsLocationsSearchAssignments_580135(
    name: "bigqueryreservationProjectsLocationsSearchAssignments",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}:searchAssignments",
    validator: validate_BigqueryreservationProjectsLocationsSearchAssignments_580136,
    base: "/", url: url_BigqueryreservationProjectsLocationsSearchAssignments_580137,
    schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
