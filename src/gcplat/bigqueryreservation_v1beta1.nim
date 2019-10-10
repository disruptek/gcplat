
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "bigqueryreservation"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigqueryreservationProjectsLocationsReservationsGet_588710 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsGet_588712(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsGet_588711(
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
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_BigqueryreservationProjectsLocationsReservationsGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the reservation.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_BigqueryreservationProjectsLocationsReservationsGet_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsGet
  ## Returns information about the reservation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name of the reservation to retrieve. E.g.,
  ##    projects/myproject/locations/US/reservations/team1-prod
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
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(path_588957, "name", newJString(name))
  add(query_588959, "alt", newJString(alt))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsGet* = Call_BigqueryreservationProjectsLocationsReservationsGet_588710(
    name: "bigqueryreservationProjectsLocationsReservationsGet",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_BigqueryreservationProjectsLocationsReservationsGet_588711,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsGet_588712,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsPatch_589017 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsPatch_589019(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsPatch_589018(
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
  var valid_589020 = path.getOrDefault("name")
  valid_589020 = validateParameter(valid_589020, JString, required = true,
                                 default = nil)
  if valid_589020 != nil:
    section.add "name", valid_589020
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
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  section = newJObject()
  var valid_589021 = query.getOrDefault("upload_protocol")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "upload_protocol", valid_589021
  var valid_589022 = query.getOrDefault("fields")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "fields", valid_589022
  var valid_589023 = query.getOrDefault("quotaUser")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "quotaUser", valid_589023
  var valid_589024 = query.getOrDefault("alt")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = newJString("json"))
  if valid_589024 != nil:
    section.add "alt", valid_589024
  var valid_589025 = query.getOrDefault("oauth_token")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "oauth_token", valid_589025
  var valid_589026 = query.getOrDefault("callback")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "callback", valid_589026
  var valid_589027 = query.getOrDefault("access_token")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "access_token", valid_589027
  var valid_589028 = query.getOrDefault("uploadType")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "uploadType", valid_589028
  var valid_589029 = query.getOrDefault("key")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "key", valid_589029
  var valid_589030 = query.getOrDefault("$.xgafv")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = newJString("1"))
  if valid_589030 != nil:
    section.add "$.xgafv", valid_589030
  var valid_589031 = query.getOrDefault("prettyPrint")
  valid_589031 = validateParameter(valid_589031, JBool, required = false,
                                 default = newJBool(true))
  if valid_589031 != nil:
    section.add "prettyPrint", valid_589031
  var valid_589032 = query.getOrDefault("updateMask")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "updateMask", valid_589032
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

proc call*(call_589034: Call_BigqueryreservationProjectsLocationsReservationsPatch_589017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing reservation resource.
  ## 
  let valid = call_589034.validator(path, query, header, formData, body)
  let scheme = call_589034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589034.url(scheme.get, call_589034.host, call_589034.base,
                         call_589034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589034, url, valid)

proc call*(call_589035: Call_BigqueryreservationProjectsLocationsReservationsPatch_589017;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsPatch
  ## Updates an existing reservation resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the reservation, e.g.,
  ## "projects/*/locations/*/reservations/team1-prod".
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
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  var path_589036 = newJObject()
  var query_589037 = newJObject()
  var body_589038 = newJObject()
  add(query_589037, "upload_protocol", newJString(uploadProtocol))
  add(query_589037, "fields", newJString(fields))
  add(query_589037, "quotaUser", newJString(quotaUser))
  add(path_589036, "name", newJString(name))
  add(query_589037, "alt", newJString(alt))
  add(query_589037, "oauth_token", newJString(oauthToken))
  add(query_589037, "callback", newJString(callback))
  add(query_589037, "access_token", newJString(accessToken))
  add(query_589037, "uploadType", newJString(uploadType))
  add(query_589037, "key", newJString(key))
  add(query_589037, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589038 = body
  add(query_589037, "prettyPrint", newJBool(prettyPrint))
  add(query_589037, "updateMask", newJString(updateMask))
  result = call_589035.call(path_589036, query_589037, nil, nil, body_589038)

var bigqueryreservationProjectsLocationsReservationsPatch* = Call_BigqueryreservationProjectsLocationsReservationsPatch_589017(
    name: "bigqueryreservationProjectsLocationsReservationsPatch",
    meth: HttpMethod.HttpPatch, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_BigqueryreservationProjectsLocationsReservationsPatch_589018,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsPatch_589019,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_588998 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_589000(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_588999(
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
  var valid_589001 = path.getOrDefault("name")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "name", valid_589001
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
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("$.xgafv")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("1"))
  if valid_589011 != nil:
    section.add "$.xgafv", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589013: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_588998;
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
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_588998;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the resource, e.g.:
  ##   projects/myproject/locations/US/reservations/team1-prod/assignments/123
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
  var path_589015 = newJObject()
  var query_589016 = newJObject()
  add(query_589016, "upload_protocol", newJString(uploadProtocol))
  add(query_589016, "fields", newJString(fields))
  add(query_589016, "quotaUser", newJString(quotaUser))
  add(path_589015, "name", newJString(name))
  add(query_589016, "alt", newJString(alt))
  add(query_589016, "oauth_token", newJString(oauthToken))
  add(query_589016, "callback", newJString(callback))
  add(query_589016, "access_token", newJString(accessToken))
  add(query_589016, "uploadType", newJString(uploadType))
  add(query_589016, "key", newJString(key))
  add(query_589016, "$.xgafv", newJString(Xgafv))
  add(query_589016, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(path_589015, query_589016, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsAssignmentsDelete* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_588998(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsDelete",
    meth: HttpMethod.HttpDelete, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_588999,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_589000,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsList_589039 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsList_589041(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsList_589040(path: JsonNode;
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
  var valid_589042 = path.getOrDefault("name")
  valid_589042 = validateParameter(valid_589042, JString, required = true,
                                 default = nil)
  if valid_589042 != nil:
    section.add "name", valid_589042
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_589043 = query.getOrDefault("upload_protocol")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "upload_protocol", valid_589043
  var valid_589044 = query.getOrDefault("fields")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "fields", valid_589044
  var valid_589045 = query.getOrDefault("pageToken")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "pageToken", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("callback")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "callback", valid_589049
  var valid_589050 = query.getOrDefault("access_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "access_token", valid_589050
  var valid_589051 = query.getOrDefault("uploadType")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "uploadType", valid_589051
  var valid_589052 = query.getOrDefault("key")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "key", valid_589052
  var valid_589053 = query.getOrDefault("$.xgafv")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = newJString("1"))
  if valid_589053 != nil:
    section.add "$.xgafv", valid_589053
  var valid_589054 = query.getOrDefault("pageSize")
  valid_589054 = validateParameter(valid_589054, JInt, required = false, default = nil)
  if valid_589054 != nil:
    section.add "pageSize", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
  var valid_589056 = query.getOrDefault("filter")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "filter", valid_589056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589057: Call_BigqueryreservationProjectsLocationsList_589039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_BigqueryreservationProjectsLocationsList_589039;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
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
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_589059 = newJObject()
  var query_589060 = newJObject()
  add(query_589060, "upload_protocol", newJString(uploadProtocol))
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "pageToken", newJString(pageToken))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(path_589059, "name", newJString(name))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "callback", newJString(callback))
  add(query_589060, "access_token", newJString(accessToken))
  add(query_589060, "uploadType", newJString(uploadType))
  add(query_589060, "key", newJString(key))
  add(query_589060, "$.xgafv", newJString(Xgafv))
  add(query_589060, "pageSize", newJInt(pageSize))
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  add(query_589060, "filter", newJString(filter))
  result = call_589058.call(path_589059, query_589060, nil, nil, nil)

var bigqueryreservationProjectsLocationsList* = Call_BigqueryreservationProjectsLocationsList_589039(
    name: "bigqueryreservationProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}/locations",
    validator: validate_BigqueryreservationProjectsLocationsList_589040,
    base: "/", url: url_BigqueryreservationProjectsLocationsList_589041,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsOperationsCancel_589061 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsOperationsCancel_589063(
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
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsOperationsCancel_589062(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589064 = path.getOrDefault("name")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "name", valid_589064
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
  var valid_589065 = query.getOrDefault("upload_protocol")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "upload_protocol", valid_589065
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("oauth_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "oauth_token", valid_589069
  var valid_589070 = query.getOrDefault("callback")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "callback", valid_589070
  var valid_589071 = query.getOrDefault("access_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "access_token", valid_589071
  var valid_589072 = query.getOrDefault("uploadType")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "uploadType", valid_589072
  var valid_589073 = query.getOrDefault("key")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "key", valid_589073
  var valid_589074 = query.getOrDefault("$.xgafv")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = newJString("1"))
  if valid_589074 != nil:
    section.add "$.xgafv", valid_589074
  var valid_589075 = query.getOrDefault("prettyPrint")
  valid_589075 = validateParameter(valid_589075, JBool, required = false,
                                 default = newJBool(true))
  if valid_589075 != nil:
    section.add "prettyPrint", valid_589075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589076: Call_BigqueryreservationProjectsLocationsOperationsCancel_589061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_BigqueryreservationProjectsLocationsOperationsCancel_589061;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_589078 = newJObject()
  var query_589079 = newJObject()
  add(query_589079, "upload_protocol", newJString(uploadProtocol))
  add(query_589079, "fields", newJString(fields))
  add(query_589079, "quotaUser", newJString(quotaUser))
  add(path_589078, "name", newJString(name))
  add(query_589079, "alt", newJString(alt))
  add(query_589079, "oauth_token", newJString(oauthToken))
  add(query_589079, "callback", newJString(callback))
  add(query_589079, "access_token", newJString(accessToken))
  add(query_589079, "uploadType", newJString(uploadType))
  add(query_589079, "key", newJString(key))
  add(query_589079, "$.xgafv", newJString(Xgafv))
  add(query_589079, "prettyPrint", newJBool(prettyPrint))
  result = call_589077.call(path_589078, query_589079, nil, nil, nil)

var bigqueryreservationProjectsLocationsOperationsCancel* = Call_BigqueryreservationProjectsLocationsOperationsCancel_589061(
    name: "bigqueryreservationProjectsLocationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}:cancel",
    validator: validate_BigqueryreservationProjectsLocationsOperationsCancel_589062,
    base: "/", url: url_BigqueryreservationProjectsLocationsOperationsCancel_589063,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_589080 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_589082(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_589081(
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
  var valid_589083 = path.getOrDefault("name")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "name", valid_589083
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
  ##   destinationId: JString
  ##                : The new reservation ID, e.g.:
  ##   projects/myotherproject/locations/US/reservations/team2-prod
  section = newJObject()
  var valid_589084 = query.getOrDefault("upload_protocol")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "upload_protocol", valid_589084
  var valid_589085 = query.getOrDefault("fields")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "fields", valid_589085
  var valid_589086 = query.getOrDefault("quotaUser")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "quotaUser", valid_589086
  var valid_589087 = query.getOrDefault("alt")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("json"))
  if valid_589087 != nil:
    section.add "alt", valid_589087
  var valid_589088 = query.getOrDefault("oauth_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "oauth_token", valid_589088
  var valid_589089 = query.getOrDefault("callback")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "callback", valid_589089
  var valid_589090 = query.getOrDefault("access_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "access_token", valid_589090
  var valid_589091 = query.getOrDefault("uploadType")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "uploadType", valid_589091
  var valid_589092 = query.getOrDefault("key")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "key", valid_589092
  var valid_589093 = query.getOrDefault("$.xgafv")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("1"))
  if valid_589093 != nil:
    section.add "$.xgafv", valid_589093
  var valid_589094 = query.getOrDefault("prettyPrint")
  valid_589094 = validateParameter(valid_589094, JBool, required = false,
                                 default = newJBool(true))
  if valid_589094 != nil:
    section.add "prettyPrint", valid_589094
  var valid_589095 = query.getOrDefault("destinationId")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "destinationId", valid_589095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589096: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_589080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves a assignment under a new reservation. Customers can do this by
  ## deleting the existing assignment followed by creating another assignment
  ## under the new reservation, but this method provides a transactional way to
  ## do so, to make sure the assignee always has an associated reservation.
  ## Without the method customers might see some queries run on-demand which
  ## might be unexpected.
  ## 
  let valid = call_589096.validator(path, query, header, formData, body)
  let scheme = call_589096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589096.url(scheme.get, call_589096.host, call_589096.base,
                         call_589096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589096, url, valid)

proc call*(call_589097: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_589080;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          destinationId: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsAssignmentsMove
  ## Moves a assignment under a new reservation. Customers can do this by
  ## deleting the existing assignment followed by creating another assignment
  ## under the new reservation, but this method provides a transactional way to
  ## do so, to make sure the assignee always has an associated reservation.
  ## Without the method customers might see some queries run on-demand which
  ## might be unexpected.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the assignment,
  ## e.g.:
  ##   projects/myproject/locations/US/reservations/team1-prod/assignments/123
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
  ##   destinationId: string
  ##                : The new reservation ID, e.g.:
  ##   projects/myotherproject/locations/US/reservations/team2-prod
  var path_589098 = newJObject()
  var query_589099 = newJObject()
  add(query_589099, "upload_protocol", newJString(uploadProtocol))
  add(query_589099, "fields", newJString(fields))
  add(query_589099, "quotaUser", newJString(quotaUser))
  add(path_589098, "name", newJString(name))
  add(query_589099, "alt", newJString(alt))
  add(query_589099, "oauth_token", newJString(oauthToken))
  add(query_589099, "callback", newJString(callback))
  add(query_589099, "access_token", newJString(accessToken))
  add(query_589099, "uploadType", newJString(uploadType))
  add(query_589099, "key", newJString(key))
  add(query_589099, "$.xgafv", newJString(Xgafv))
  add(query_589099, "prettyPrint", newJBool(prettyPrint))
  add(query_589099, "destinationId", newJString(destinationId))
  result = call_589097.call(path_589098, query_589099, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsAssignmentsMove* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_589080(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsMove",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}:move", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_589081,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_589082,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_589121 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_589123(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_589122(
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
  ## E.g.: projects/myproject/location/US/reservations/team1-prod
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589124 = path.getOrDefault("parent")
  valid_589124 = validateParameter(valid_589124, JString, required = true,
                                 default = nil)
  if valid_589124 != nil:
    section.add "parent", valid_589124
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
  var valid_589125 = query.getOrDefault("upload_protocol")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "upload_protocol", valid_589125
  var valid_589126 = query.getOrDefault("fields")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "fields", valid_589126
  var valid_589127 = query.getOrDefault("quotaUser")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "quotaUser", valid_589127
  var valid_589128 = query.getOrDefault("alt")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = newJString("json"))
  if valid_589128 != nil:
    section.add "alt", valid_589128
  var valid_589129 = query.getOrDefault("oauth_token")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "oauth_token", valid_589129
  var valid_589130 = query.getOrDefault("callback")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "callback", valid_589130
  var valid_589131 = query.getOrDefault("access_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "access_token", valid_589131
  var valid_589132 = query.getOrDefault("uploadType")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "uploadType", valid_589132
  var valid_589133 = query.getOrDefault("key")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "key", valid_589133
  var valid_589134 = query.getOrDefault("$.xgafv")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("1"))
  if valid_589134 != nil:
    section.add "$.xgafv", valid_589134
  var valid_589135 = query.getOrDefault("prettyPrint")
  valid_589135 = validateParameter(valid_589135, JBool, required = false,
                                 default = newJBool(true))
  if valid_589135 != nil:
    section.add "prettyPrint", valid_589135
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

proc call*(call_589137: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_589121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the assignment
  ## does not match location of the reservation.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_589121;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsAssignmentsCreate
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the assignment
  ## does not match location of the reservation.
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
  ##   parent: string (required)
  ##         : The parent resource name of the assignment
  ## E.g.: projects/myproject/location/US/reservations/team1-prod
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589139 = newJObject()
  var query_589140 = newJObject()
  var body_589141 = newJObject()
  add(query_589140, "upload_protocol", newJString(uploadProtocol))
  add(query_589140, "fields", newJString(fields))
  add(query_589140, "quotaUser", newJString(quotaUser))
  add(query_589140, "alt", newJString(alt))
  add(query_589140, "oauth_token", newJString(oauthToken))
  add(query_589140, "callback", newJString(callback))
  add(query_589140, "access_token", newJString(accessToken))
  add(query_589140, "uploadType", newJString(uploadType))
  add(path_589139, "parent", newJString(parent))
  add(query_589140, "key", newJString(key))
  add(query_589140, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589141 = body
  add(query_589140, "prettyPrint", newJBool(prettyPrint))
  result = call_589138.call(path_589139, query_589140, nil, nil, body_589141)

var bigqueryreservationProjectsLocationsReservationsAssignmentsCreate* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_589121(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/assignments", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_589122,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_589123,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_589100 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsList_589102(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsList_589101(
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
  ## projects/myproject/location/US/reservations/team1-prod
  ## Or:
  ## projects/myproject/location/US/reservations/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589103 = path.getOrDefault("parent")
  valid_589103 = validateParameter(valid_589103, JString, required = true,
                                 default = nil)
  if valid_589103 != nil:
    section.add "parent", valid_589103
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589104 = query.getOrDefault("upload_protocol")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "upload_protocol", valid_589104
  var valid_589105 = query.getOrDefault("fields")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "fields", valid_589105
  var valid_589106 = query.getOrDefault("pageToken")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "pageToken", valid_589106
  var valid_589107 = query.getOrDefault("quotaUser")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "quotaUser", valid_589107
  var valid_589108 = query.getOrDefault("alt")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("json"))
  if valid_589108 != nil:
    section.add "alt", valid_589108
  var valid_589109 = query.getOrDefault("oauth_token")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "oauth_token", valid_589109
  var valid_589110 = query.getOrDefault("callback")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "callback", valid_589110
  var valid_589111 = query.getOrDefault("access_token")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "access_token", valid_589111
  var valid_589112 = query.getOrDefault("uploadType")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "uploadType", valid_589112
  var valid_589113 = query.getOrDefault("key")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "key", valid_589113
  var valid_589114 = query.getOrDefault("$.xgafv")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = newJString("1"))
  if valid_589114 != nil:
    section.add "$.xgafv", valid_589114
  var valid_589115 = query.getOrDefault("pageSize")
  valid_589115 = validateParameter(valid_589115, JInt, required = false, default = nil)
  if valid_589115 != nil:
    section.add "pageSize", valid_589115
  var valid_589116 = query.getOrDefault("prettyPrint")
  valid_589116 = validateParameter(valid_589116, JBool, required = false,
                                 default = newJBool(true))
  if valid_589116 != nil:
    section.add "prettyPrint", valid_589116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589117: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_589100;
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
  let valid = call_589117.validator(path, query, header, formData, body)
  let scheme = call_589117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589117.url(scheme.get, call_589117.host, call_589117.base,
                         call_589117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589117, url, valid)

proc call*(call_589118: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_589100;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   parent: string (required)
  ##         : The parent resource name e.g.:
  ## projects/myproject/location/US/reservations/team1-prod
  ## Or:
  ## projects/myproject/location/US/reservations/-
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589119 = newJObject()
  var query_589120 = newJObject()
  add(query_589120, "upload_protocol", newJString(uploadProtocol))
  add(query_589120, "fields", newJString(fields))
  add(query_589120, "pageToken", newJString(pageToken))
  add(query_589120, "quotaUser", newJString(quotaUser))
  add(query_589120, "alt", newJString(alt))
  add(query_589120, "oauth_token", newJString(oauthToken))
  add(query_589120, "callback", newJString(callback))
  add(query_589120, "access_token", newJString(accessToken))
  add(query_589120, "uploadType", newJString(uploadType))
  add(path_589119, "parent", newJString(parent))
  add(query_589120, "key", newJString(key))
  add(query_589120, "$.xgafv", newJString(Xgafv))
  add(query_589120, "pageSize", newJInt(pageSize))
  add(query_589120, "prettyPrint", newJBool(prettyPrint))
  result = call_589118.call(path_589119, query_589120, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsAssignmentsList* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_589100(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/assignments", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsList_589101,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsList_589102,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_589142 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsCapacityCommitmentsList_589144(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsCapacityCommitmentsList_589143(
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
  var valid_589145 = path.getOrDefault("parent")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "parent", valid_589145
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589146 = query.getOrDefault("upload_protocol")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "upload_protocol", valid_589146
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("pageToken")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "pageToken", valid_589148
  var valid_589149 = query.getOrDefault("quotaUser")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "quotaUser", valid_589149
  var valid_589150 = query.getOrDefault("alt")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = newJString("json"))
  if valid_589150 != nil:
    section.add "alt", valid_589150
  var valid_589151 = query.getOrDefault("oauth_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "oauth_token", valid_589151
  var valid_589152 = query.getOrDefault("callback")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "callback", valid_589152
  var valid_589153 = query.getOrDefault("access_token")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "access_token", valid_589153
  var valid_589154 = query.getOrDefault("uploadType")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "uploadType", valid_589154
  var valid_589155 = query.getOrDefault("key")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "key", valid_589155
  var valid_589156 = query.getOrDefault("$.xgafv")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("1"))
  if valid_589156 != nil:
    section.add "$.xgafv", valid_589156
  var valid_589157 = query.getOrDefault("pageSize")
  valid_589157 = validateParameter(valid_589157, JInt, required = false, default = nil)
  if valid_589157 != nil:
    section.add "pageSize", valid_589157
  var valid_589158 = query.getOrDefault("prettyPrint")
  valid_589158 = validateParameter(valid_589158, JBool, required = false,
                                 default = newJBool(true))
  if valid_589158 != nil:
    section.add "prettyPrint", valid_589158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589159: Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_589142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the capacity commitments for the admin project.
  ## 
  let valid = call_589159.validator(path, query, header, formData, body)
  let scheme = call_589159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589159.url(scheme.get, call_589159.host, call_589159.base,
                         call_589159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589159, url, valid)

proc call*(call_589160: Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_589142;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsCapacityCommitmentsList
  ## Lists all the capacity commitments for the admin project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   parent: string (required)
  ##         : Resource name of the parent reservation. E.g.,
  ##    projects/myproject/locations/US
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589161 = newJObject()
  var query_589162 = newJObject()
  add(query_589162, "upload_protocol", newJString(uploadProtocol))
  add(query_589162, "fields", newJString(fields))
  add(query_589162, "pageToken", newJString(pageToken))
  add(query_589162, "quotaUser", newJString(quotaUser))
  add(query_589162, "alt", newJString(alt))
  add(query_589162, "oauth_token", newJString(oauthToken))
  add(query_589162, "callback", newJString(callback))
  add(query_589162, "access_token", newJString(accessToken))
  add(query_589162, "uploadType", newJString(uploadType))
  add(path_589161, "parent", newJString(parent))
  add(query_589162, "key", newJString(key))
  add(query_589162, "$.xgafv", newJString(Xgafv))
  add(query_589162, "pageSize", newJInt(pageSize))
  add(query_589162, "prettyPrint", newJBool(prettyPrint))
  result = call_589160.call(path_589161, query_589162, nil, nil, nil)

var bigqueryreservationProjectsLocationsCapacityCommitmentsList* = Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_589142(
    name: "bigqueryreservationProjectsLocationsCapacityCommitmentsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/capacityCommitments", validator: validate_BigqueryreservationProjectsLocationsCapacityCommitmentsList_589143,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsCapacityCommitmentsList_589144,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsCreate_589185 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsCreate_589187(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsCreate_589186(
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
  var valid_589188 = path.getOrDefault("parent")
  valid_589188 = validateParameter(valid_589188, JString, required = true,
                                 default = nil)
  if valid_589188 != nil:
    section.add "parent", valid_589188
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
  ##   reservationId: JString
  ##                : The reservation ID. This field must only contain alphanumeric characters or
  ## dash.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589189 = query.getOrDefault("upload_protocol")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "upload_protocol", valid_589189
  var valid_589190 = query.getOrDefault("fields")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "fields", valid_589190
  var valid_589191 = query.getOrDefault("quotaUser")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "quotaUser", valid_589191
  var valid_589192 = query.getOrDefault("alt")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = newJString("json"))
  if valid_589192 != nil:
    section.add "alt", valid_589192
  var valid_589193 = query.getOrDefault("oauth_token")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "oauth_token", valid_589193
  var valid_589194 = query.getOrDefault("callback")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "callback", valid_589194
  var valid_589195 = query.getOrDefault("access_token")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "access_token", valid_589195
  var valid_589196 = query.getOrDefault("uploadType")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "uploadType", valid_589196
  var valid_589197 = query.getOrDefault("reservationId")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "reservationId", valid_589197
  var valid_589198 = query.getOrDefault("key")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "key", valid_589198
  var valid_589199 = query.getOrDefault("$.xgafv")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("1"))
  if valid_589199 != nil:
    section.add "$.xgafv", valid_589199
  var valid_589200 = query.getOrDefault("prettyPrint")
  valid_589200 = validateParameter(valid_589200, JBool, required = false,
                                 default = newJBool(true))
  if valid_589200 != nil:
    section.add "prettyPrint", valid_589200
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

proc call*(call_589202: Call_BigqueryreservationProjectsLocationsReservationsCreate_589185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new reservation resource.
  ## 
  let valid = call_589202.validator(path, query, header, formData, body)
  let scheme = call_589202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589202.url(scheme.get, call_589202.host, call_589202.base,
                         call_589202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589202, url, valid)

proc call*(call_589203: Call_BigqueryreservationProjectsLocationsReservationsCreate_589185;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          reservationId: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsCreate
  ## Creates a new reservation resource.
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
  ##   parent: string (required)
  ##         : Project, location. E.g.,
  ##    projects/myproject/locations/US
  ##   reservationId: string
  ##                : The reservation ID. This field must only contain alphanumeric characters or
  ## dash.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589204 = newJObject()
  var query_589205 = newJObject()
  var body_589206 = newJObject()
  add(query_589205, "upload_protocol", newJString(uploadProtocol))
  add(query_589205, "fields", newJString(fields))
  add(query_589205, "quotaUser", newJString(quotaUser))
  add(query_589205, "alt", newJString(alt))
  add(query_589205, "oauth_token", newJString(oauthToken))
  add(query_589205, "callback", newJString(callback))
  add(query_589205, "access_token", newJString(accessToken))
  add(query_589205, "uploadType", newJString(uploadType))
  add(path_589204, "parent", newJString(parent))
  add(query_589205, "reservationId", newJString(reservationId))
  add(query_589205, "key", newJString(key))
  add(query_589205, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589206 = body
  add(query_589205, "prettyPrint", newJBool(prettyPrint))
  result = call_589203.call(path_589204, query_589205, nil, nil, body_589206)

var bigqueryreservationProjectsLocationsReservationsCreate* = Call_BigqueryreservationProjectsLocationsReservationsCreate_589185(
    name: "bigqueryreservationProjectsLocationsReservationsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsCreate_589186,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsCreate_589187,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsList_589163 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsReservationsList_589165(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsReservationsList_589164(
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
  var valid_589166 = path.getOrDefault("parent")
  valid_589166 = validateParameter(valid_589166, JString, required = true,
                                 default = nil)
  if valid_589166 != nil:
    section.add "parent", valid_589166
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Can be used to filter out reservations based on names, capacity, etc, e.g.:
  ## filter="reservation.slot_capacity > 200"
  ## filter="reservation.name = \"*dev/*\""
  ## Advanced filtering syntax can be
  ## [here](https://cloud.google.com/logging/docs/view/advanced-filters).
  section = newJObject()
  var valid_589167 = query.getOrDefault("upload_protocol")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "upload_protocol", valid_589167
  var valid_589168 = query.getOrDefault("fields")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "fields", valid_589168
  var valid_589169 = query.getOrDefault("pageToken")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "pageToken", valid_589169
  var valid_589170 = query.getOrDefault("quotaUser")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "quotaUser", valid_589170
  var valid_589171 = query.getOrDefault("alt")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = newJString("json"))
  if valid_589171 != nil:
    section.add "alt", valid_589171
  var valid_589172 = query.getOrDefault("oauth_token")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "oauth_token", valid_589172
  var valid_589173 = query.getOrDefault("callback")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "callback", valid_589173
  var valid_589174 = query.getOrDefault("access_token")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "access_token", valid_589174
  var valid_589175 = query.getOrDefault("uploadType")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "uploadType", valid_589175
  var valid_589176 = query.getOrDefault("key")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "key", valid_589176
  var valid_589177 = query.getOrDefault("$.xgafv")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("1"))
  if valid_589177 != nil:
    section.add "$.xgafv", valid_589177
  var valid_589178 = query.getOrDefault("pageSize")
  valid_589178 = validateParameter(valid_589178, JInt, required = false, default = nil)
  if valid_589178 != nil:
    section.add "pageSize", valid_589178
  var valid_589179 = query.getOrDefault("prettyPrint")
  valid_589179 = validateParameter(valid_589179, JBool, required = false,
                                 default = newJBool(true))
  if valid_589179 != nil:
    section.add "prettyPrint", valid_589179
  var valid_589180 = query.getOrDefault("filter")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "filter", valid_589180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589181: Call_BigqueryreservationProjectsLocationsReservationsList_589163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the reservations for the project in the specified location.
  ## 
  let valid = call_589181.validator(path, query, header, formData, body)
  let scheme = call_589181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589181.url(scheme.get, call_589181.host, call_589181.base,
                         call_589181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589181, url, valid)

proc call*(call_589182: Call_BigqueryreservationProjectsLocationsReservationsList_589163;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## bigqueryreservationProjectsLocationsReservationsList
  ## Lists all the reservations for the project in the specified location.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   parent: string (required)
  ##         : The parent resource name containing project and location, e.g.:
  ##   "projects/myproject/locations/US"
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Can be used to filter out reservations based on names, capacity, etc, e.g.:
  ## filter="reservation.slot_capacity > 200"
  ## filter="reservation.name = \"*dev/*\""
  ## Advanced filtering syntax can be
  ## [here](https://cloud.google.com/logging/docs/view/advanced-filters).
  var path_589183 = newJObject()
  var query_589184 = newJObject()
  add(query_589184, "upload_protocol", newJString(uploadProtocol))
  add(query_589184, "fields", newJString(fields))
  add(query_589184, "pageToken", newJString(pageToken))
  add(query_589184, "quotaUser", newJString(quotaUser))
  add(query_589184, "alt", newJString(alt))
  add(query_589184, "oauth_token", newJString(oauthToken))
  add(query_589184, "callback", newJString(callback))
  add(query_589184, "access_token", newJString(accessToken))
  add(query_589184, "uploadType", newJString(uploadType))
  add(path_589183, "parent", newJString(parent))
  add(query_589184, "key", newJString(key))
  add(query_589184, "$.xgafv", newJString(Xgafv))
  add(query_589184, "pageSize", newJInt(pageSize))
  add(query_589184, "prettyPrint", newJBool(prettyPrint))
  add(query_589184, "filter", newJString(filter))
  result = call_589182.call(path_589183, query_589184, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsList* = Call_BigqueryreservationProjectsLocationsReservationsList_589163(
    name: "bigqueryreservationProjectsLocationsReservationsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsList_589164,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsList_589165,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsSearchAssignments_589207 = ref object of OpenApiRestCall_588441
proc url_BigqueryreservationProjectsLocationsSearchAssignments_589209(
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
  result.path = base & hydrated.get

proc validate_BigqueryreservationProjectsLocationsSearchAssignments_589208(
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
  ## Wildcard "-" can be used for projects in
  ## SearchAssignmentsRequest.parent. Note "-" cannot be used for projects
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
  var valid_589210 = path.getOrDefault("parent")
  valid_589210 = validateParameter(valid_589210, JString, required = true,
                                 default = nil)
  if valid_589210 != nil:
    section.add "parent", valid_589210
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : Please specify resource name as assignee in the query.
  ## e.g., "assignee=projects/myproject"
  ##       "assignee=folders/123"
  ##       "assignee=organizations/456"
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
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589211 = query.getOrDefault("upload_protocol")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "upload_protocol", valid_589211
  var valid_589212 = query.getOrDefault("fields")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "fields", valid_589212
  var valid_589213 = query.getOrDefault("pageToken")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "pageToken", valid_589213
  var valid_589214 = query.getOrDefault("quotaUser")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "quotaUser", valid_589214
  var valid_589215 = query.getOrDefault("alt")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = newJString("json"))
  if valid_589215 != nil:
    section.add "alt", valid_589215
  var valid_589216 = query.getOrDefault("query")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "query", valid_589216
  var valid_589217 = query.getOrDefault("oauth_token")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "oauth_token", valid_589217
  var valid_589218 = query.getOrDefault("callback")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "callback", valid_589218
  var valid_589219 = query.getOrDefault("access_token")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "access_token", valid_589219
  var valid_589220 = query.getOrDefault("uploadType")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "uploadType", valid_589220
  var valid_589221 = query.getOrDefault("key")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "key", valid_589221
  var valid_589222 = query.getOrDefault("$.xgafv")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = newJString("1"))
  if valid_589222 != nil:
    section.add "$.xgafv", valid_589222
  var valid_589223 = query.getOrDefault("pageSize")
  valid_589223 = validateParameter(valid_589223, JInt, required = false, default = nil)
  if valid_589223 != nil:
    section.add "pageSize", valid_589223
  var valid_589224 = query.getOrDefault("prettyPrint")
  valid_589224 = validateParameter(valid_589224, JBool, required = false,
                                 default = newJBool(true))
  if valid_589224 != nil:
    section.add "prettyPrint", valid_589224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589225: Call_BigqueryreservationProjectsLocationsSearchAssignments_589207;
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
  ## Wildcard "-" can be used for projects in
  ## SearchAssignmentsRequest.parent. Note "-" cannot be used for projects
  ## nor locations.
  ## 
  let valid = call_589225.validator(path, query, header, formData, body)
  let scheme = call_589225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589225.url(scheme.get, call_589225.host, call_589225.base,
                         call_589225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589225, url, valid)

proc call*(call_589226: Call_BigqueryreservationProjectsLocationsSearchAssignments_589207;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
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
  ## Wildcard "-" can be used for projects in
  ## SearchAssignmentsRequest.parent. Note "-" cannot be used for projects
  ## nor locations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : Please specify resource name as assignee in the query.
  ## e.g., "assignee=projects/myproject"
  ##       "assignee=folders/123"
  ##       "assignee=organizations/456"
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The resource name of the admin project(containing project and location),
  ## e.g.:
  ##   "projects/myproject/locations/US".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589227 = newJObject()
  var query_589228 = newJObject()
  add(query_589228, "upload_protocol", newJString(uploadProtocol))
  add(query_589228, "fields", newJString(fields))
  add(query_589228, "pageToken", newJString(pageToken))
  add(query_589228, "quotaUser", newJString(quotaUser))
  add(query_589228, "alt", newJString(alt))
  add(query_589228, "query", newJString(query))
  add(query_589228, "oauth_token", newJString(oauthToken))
  add(query_589228, "callback", newJString(callback))
  add(query_589228, "access_token", newJString(accessToken))
  add(query_589228, "uploadType", newJString(uploadType))
  add(path_589227, "parent", newJString(parent))
  add(query_589228, "key", newJString(key))
  add(query_589228, "$.xgafv", newJString(Xgafv))
  add(query_589228, "pageSize", newJInt(pageSize))
  add(query_589228, "prettyPrint", newJBool(prettyPrint))
  result = call_589226.call(path_589227, query_589228, nil, nil, nil)

var bigqueryreservationProjectsLocationsSearchAssignments* = Call_BigqueryreservationProjectsLocationsSearchAssignments_589207(
    name: "bigqueryreservationProjectsLocationsSearchAssignments",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}:searchAssignments",
    validator: validate_BigqueryreservationProjectsLocationsSearchAssignments_589208,
    base: "/", url: url_BigqueryreservationProjectsLocationsSearchAssignments_589209,
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
