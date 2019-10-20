
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  Call_BigqueryreservationProjectsLocationsReservationsGet_578610 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsGet_578612(
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

proc validate_BigqueryreservationProjectsLocationsReservationsGet_578611(
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
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_BigqueryreservationProjectsLocationsReservationsGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the reservation.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_BigqueryreservationProjectsLocationsReservationsGet_578610;
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
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(path_578857, "name", newJString(name))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsGet* = Call_BigqueryreservationProjectsLocationsReservationsGet_578610(
    name: "bigqueryreservationProjectsLocationsReservationsGet",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_BigqueryreservationProjectsLocationsReservationsGet_578611,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsGet_578612,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsPatch_578917 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsPatch_578919(
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

proc validate_BigqueryreservationProjectsLocationsReservationsPatch_578918(
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
  var valid_578920 = path.getOrDefault("name")
  valid_578920 = validateParameter(valid_578920, JString, required = true,
                                 default = nil)
  if valid_578920 != nil:
    section.add "name", valid_578920
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
  var valid_578921 = query.getOrDefault("key")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "key", valid_578921
  var valid_578922 = query.getOrDefault("prettyPrint")
  valid_578922 = validateParameter(valid_578922, JBool, required = false,
                                 default = newJBool(true))
  if valid_578922 != nil:
    section.add "prettyPrint", valid_578922
  var valid_578923 = query.getOrDefault("oauth_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "oauth_token", valid_578923
  var valid_578924 = query.getOrDefault("$.xgafv")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = newJString("1"))
  if valid_578924 != nil:
    section.add "$.xgafv", valid_578924
  var valid_578925 = query.getOrDefault("alt")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("json"))
  if valid_578925 != nil:
    section.add "alt", valid_578925
  var valid_578926 = query.getOrDefault("uploadType")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "uploadType", valid_578926
  var valid_578927 = query.getOrDefault("quotaUser")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "quotaUser", valid_578927
  var valid_578928 = query.getOrDefault("updateMask")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "updateMask", valid_578928
  var valid_578929 = query.getOrDefault("callback")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "callback", valid_578929
  var valid_578930 = query.getOrDefault("fields")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "fields", valid_578930
  var valid_578931 = query.getOrDefault("access_token")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "access_token", valid_578931
  var valid_578932 = query.getOrDefault("upload_protocol")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "upload_protocol", valid_578932
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

proc call*(call_578934: Call_BigqueryreservationProjectsLocationsReservationsPatch_578917;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing reservation resource.
  ## 
  let valid = call_578934.validator(path, query, header, formData, body)
  let scheme = call_578934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578934.url(scheme.get, call_578934.host, call_578934.base,
                         call_578934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578934, url, valid)

proc call*(call_578935: Call_BigqueryreservationProjectsLocationsReservationsPatch_578917;
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
  var path_578936 = newJObject()
  var query_578937 = newJObject()
  var body_578938 = newJObject()
  add(query_578937, "key", newJString(key))
  add(query_578937, "prettyPrint", newJBool(prettyPrint))
  add(query_578937, "oauth_token", newJString(oauthToken))
  add(query_578937, "$.xgafv", newJString(Xgafv))
  add(query_578937, "alt", newJString(alt))
  add(query_578937, "uploadType", newJString(uploadType))
  add(query_578937, "quotaUser", newJString(quotaUser))
  add(path_578936, "name", newJString(name))
  add(query_578937, "updateMask", newJString(updateMask))
  if body != nil:
    body_578938 = body
  add(query_578937, "callback", newJString(callback))
  add(query_578937, "fields", newJString(fields))
  add(query_578937, "access_token", newJString(accessToken))
  add(query_578937, "upload_protocol", newJString(uploadProtocol))
  result = call_578935.call(path_578936, query_578937, nil, nil, body_578938)

var bigqueryreservationProjectsLocationsReservationsPatch* = Call_BigqueryreservationProjectsLocationsReservationsPatch_578917(
    name: "bigqueryreservationProjectsLocationsReservationsPatch",
    meth: HttpMethod.HttpPatch, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_BigqueryreservationProjectsLocationsReservationsPatch_578918,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsPatch_578919,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_578898 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_578900(
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

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_578899(
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
  var valid_578901 = path.getOrDefault("name")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "name", valid_578901
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
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("callback")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "callback", valid_578909
  var valid_578910 = query.getOrDefault("fields")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "fields", valid_578910
  var valid_578911 = query.getOrDefault("access_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "access_token", valid_578911
  var valid_578912 = query.getOrDefault("upload_protocol")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "upload_protocol", valid_578912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578913: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_578898;
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
  let valid = call_578913.validator(path, query, header, formData, body)
  let scheme = call_578913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578913.url(scheme.get, call_578913.host, call_578913.base,
                         call_578913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578913, url, valid)

proc call*(call_578914: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_578898;
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
  var path_578915 = newJObject()
  var query_578916 = newJObject()
  add(query_578916, "key", newJString(key))
  add(query_578916, "prettyPrint", newJBool(prettyPrint))
  add(query_578916, "oauth_token", newJString(oauthToken))
  add(query_578916, "$.xgafv", newJString(Xgafv))
  add(query_578916, "alt", newJString(alt))
  add(query_578916, "uploadType", newJString(uploadType))
  add(query_578916, "quotaUser", newJString(quotaUser))
  add(path_578915, "name", newJString(name))
  add(query_578916, "callback", newJString(callback))
  add(query_578916, "fields", newJString(fields))
  add(query_578916, "access_token", newJString(accessToken))
  add(query_578916, "upload_protocol", newJString(uploadProtocol))
  result = call_578914.call(path_578915, query_578916, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsAssignmentsDelete* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_578898(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsDelete",
    meth: HttpMethod.HttpDelete, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_578899,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsDelete_578900,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsList_578939 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsList_578941(protocol: Scheme;
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

proc validate_BigqueryreservationProjectsLocationsList_578940(path: JsonNode;
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
  var valid_578942 = path.getOrDefault("name")
  valid_578942 = validateParameter(valid_578942, JString, required = true,
                                 default = nil)
  if valid_578942 != nil:
    section.add "name", valid_578942
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
  var valid_578943 = query.getOrDefault("key")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "key", valid_578943
  var valid_578944 = query.getOrDefault("prettyPrint")
  valid_578944 = validateParameter(valid_578944, JBool, required = false,
                                 default = newJBool(true))
  if valid_578944 != nil:
    section.add "prettyPrint", valid_578944
  var valid_578945 = query.getOrDefault("oauth_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "oauth_token", valid_578945
  var valid_578946 = query.getOrDefault("$.xgafv")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("1"))
  if valid_578946 != nil:
    section.add "$.xgafv", valid_578946
  var valid_578947 = query.getOrDefault("pageSize")
  valid_578947 = validateParameter(valid_578947, JInt, required = false, default = nil)
  if valid_578947 != nil:
    section.add "pageSize", valid_578947
  var valid_578948 = query.getOrDefault("alt")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("json"))
  if valid_578948 != nil:
    section.add "alt", valid_578948
  var valid_578949 = query.getOrDefault("uploadType")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "uploadType", valid_578949
  var valid_578950 = query.getOrDefault("quotaUser")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "quotaUser", valid_578950
  var valid_578951 = query.getOrDefault("filter")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "filter", valid_578951
  var valid_578952 = query.getOrDefault("pageToken")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "pageToken", valid_578952
  var valid_578953 = query.getOrDefault("callback")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "callback", valid_578953
  var valid_578954 = query.getOrDefault("fields")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "fields", valid_578954
  var valid_578955 = query.getOrDefault("access_token")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "access_token", valid_578955
  var valid_578956 = query.getOrDefault("upload_protocol")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "upload_protocol", valid_578956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578957: Call_BigqueryreservationProjectsLocationsList_578939;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_BigqueryreservationProjectsLocationsList_578939;
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
  var path_578959 = newJObject()
  var query_578960 = newJObject()
  add(query_578960, "key", newJString(key))
  add(query_578960, "prettyPrint", newJBool(prettyPrint))
  add(query_578960, "oauth_token", newJString(oauthToken))
  add(query_578960, "$.xgafv", newJString(Xgafv))
  add(query_578960, "pageSize", newJInt(pageSize))
  add(query_578960, "alt", newJString(alt))
  add(query_578960, "uploadType", newJString(uploadType))
  add(query_578960, "quotaUser", newJString(quotaUser))
  add(path_578959, "name", newJString(name))
  add(query_578960, "filter", newJString(filter))
  add(query_578960, "pageToken", newJString(pageToken))
  add(query_578960, "callback", newJString(callback))
  add(query_578960, "fields", newJString(fields))
  add(query_578960, "access_token", newJString(accessToken))
  add(query_578960, "upload_protocol", newJString(uploadProtocol))
  result = call_578958.call(path_578959, query_578960, nil, nil, nil)

var bigqueryreservationProjectsLocationsList* = Call_BigqueryreservationProjectsLocationsList_578939(
    name: "bigqueryreservationProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}/locations",
    validator: validate_BigqueryreservationProjectsLocationsList_578940,
    base: "/", url: url_BigqueryreservationProjectsLocationsList_578941,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsOperationsCancel_578961 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsOperationsCancel_578963(
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

proc validate_BigqueryreservationProjectsLocationsOperationsCancel_578962(
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
  var valid_578964 = path.getOrDefault("name")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "name", valid_578964
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
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("prettyPrint")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "prettyPrint", valid_578966
  var valid_578967 = query.getOrDefault("oauth_token")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "oauth_token", valid_578967
  var valid_578968 = query.getOrDefault("$.xgafv")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("1"))
  if valid_578968 != nil:
    section.add "$.xgafv", valid_578968
  var valid_578969 = query.getOrDefault("alt")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("json"))
  if valid_578969 != nil:
    section.add "alt", valid_578969
  var valid_578970 = query.getOrDefault("uploadType")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "uploadType", valid_578970
  var valid_578971 = query.getOrDefault("quotaUser")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "quotaUser", valid_578971
  var valid_578972 = query.getOrDefault("callback")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "callback", valid_578972
  var valid_578973 = query.getOrDefault("fields")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "fields", valid_578973
  var valid_578974 = query.getOrDefault("access_token")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "access_token", valid_578974
  var valid_578975 = query.getOrDefault("upload_protocol")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "upload_protocol", valid_578975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578976: Call_BigqueryreservationProjectsLocationsOperationsCancel_578961;
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
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_BigqueryreservationProjectsLocationsOperationsCancel_578961;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##       : The name of the operation resource to be cancelled.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578978 = newJObject()
  var query_578979 = newJObject()
  add(query_578979, "key", newJString(key))
  add(query_578979, "prettyPrint", newJBool(prettyPrint))
  add(query_578979, "oauth_token", newJString(oauthToken))
  add(query_578979, "$.xgafv", newJString(Xgafv))
  add(query_578979, "alt", newJString(alt))
  add(query_578979, "uploadType", newJString(uploadType))
  add(query_578979, "quotaUser", newJString(quotaUser))
  add(path_578978, "name", newJString(name))
  add(query_578979, "callback", newJString(callback))
  add(query_578979, "fields", newJString(fields))
  add(query_578979, "access_token", newJString(accessToken))
  add(query_578979, "upload_protocol", newJString(uploadProtocol))
  result = call_578977.call(path_578978, query_578979, nil, nil, nil)

var bigqueryreservationProjectsLocationsOperationsCancel* = Call_BigqueryreservationProjectsLocationsOperationsCancel_578961(
    name: "bigqueryreservationProjectsLocationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}:cancel",
    validator: validate_BigqueryreservationProjectsLocationsOperationsCancel_578962,
    base: "/", url: url_BigqueryreservationProjectsLocationsOperationsCancel_578963,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_578980 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_578982(
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

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_578981(
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
  var valid_578983 = path.getOrDefault("name")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "name", valid_578983
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
  ##   destinationId: JString
  ##                : The new reservation ID, e.g.:
  ##   projects/myotherproject/locations/US/reservations/team2-prod
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578984 = query.getOrDefault("key")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "key", valid_578984
  var valid_578985 = query.getOrDefault("prettyPrint")
  valid_578985 = validateParameter(valid_578985, JBool, required = false,
                                 default = newJBool(true))
  if valid_578985 != nil:
    section.add "prettyPrint", valid_578985
  var valid_578986 = query.getOrDefault("oauth_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "oauth_token", valid_578986
  var valid_578987 = query.getOrDefault("$.xgafv")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("1"))
  if valid_578987 != nil:
    section.add "$.xgafv", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("uploadType")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "uploadType", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("destinationId")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "destinationId", valid_578991
  var valid_578992 = query.getOrDefault("callback")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "callback", valid_578992
  var valid_578993 = query.getOrDefault("fields")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "fields", valid_578993
  var valid_578994 = query.getOrDefault("access_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "access_token", valid_578994
  var valid_578995 = query.getOrDefault("upload_protocol")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "upload_protocol", valid_578995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578996: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_578980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Moves a assignment under a new reservation. Customers can do this by
  ## deleting the existing assignment followed by creating another assignment
  ## under the new reservation, but this method provides a transactional way to
  ## do so, to make sure the assignee always has an associated reservation.
  ## Without the method customers might see some queries run on-demand which
  ## might be unexpected.
  ## 
  let valid = call_578996.validator(path, query, header, formData, body)
  let scheme = call_578996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578996.url(scheme.get, call_578996.host, call_578996.base,
                         call_578996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578996, url, valid)

proc call*(call_578997: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_578980;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; destinationId: string = "";
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
  ##   destinationId: string
  ##                : The new reservation ID, e.g.:
  ##   projects/myotherproject/locations/US/reservations/team2-prod
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578998 = newJObject()
  var query_578999 = newJObject()
  add(query_578999, "key", newJString(key))
  add(query_578999, "prettyPrint", newJBool(prettyPrint))
  add(query_578999, "oauth_token", newJString(oauthToken))
  add(query_578999, "$.xgafv", newJString(Xgafv))
  add(query_578999, "alt", newJString(alt))
  add(query_578999, "uploadType", newJString(uploadType))
  add(query_578999, "quotaUser", newJString(quotaUser))
  add(path_578998, "name", newJString(name))
  add(query_578999, "destinationId", newJString(destinationId))
  add(query_578999, "callback", newJString(callback))
  add(query_578999, "fields", newJString(fields))
  add(query_578999, "access_token", newJString(accessToken))
  add(query_578999, "upload_protocol", newJString(uploadProtocol))
  result = call_578997.call(path_578998, query_578999, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsAssignmentsMove* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_578980(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsMove",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{name}:move", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_578981,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsMove_578982,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_579021 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_579023(
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

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_579022(
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
  var valid_579024 = path.getOrDefault("parent")
  valid_579024 = validateParameter(valid_579024, JString, required = true,
                                 default = nil)
  if valid_579024 != nil:
    section.add "parent", valid_579024
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
  var valid_579025 = query.getOrDefault("key")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "key", valid_579025
  var valid_579026 = query.getOrDefault("prettyPrint")
  valid_579026 = validateParameter(valid_579026, JBool, required = false,
                                 default = newJBool(true))
  if valid_579026 != nil:
    section.add "prettyPrint", valid_579026
  var valid_579027 = query.getOrDefault("oauth_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "oauth_token", valid_579027
  var valid_579028 = query.getOrDefault("$.xgafv")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = newJString("1"))
  if valid_579028 != nil:
    section.add "$.xgafv", valid_579028
  var valid_579029 = query.getOrDefault("alt")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = newJString("json"))
  if valid_579029 != nil:
    section.add "alt", valid_579029
  var valid_579030 = query.getOrDefault("uploadType")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "uploadType", valid_579030
  var valid_579031 = query.getOrDefault("quotaUser")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "quotaUser", valid_579031
  var valid_579032 = query.getOrDefault("callback")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "callback", valid_579032
  var valid_579033 = query.getOrDefault("fields")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "fields", valid_579033
  var valid_579034 = query.getOrDefault("access_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "access_token", valid_579034
  var valid_579035 = query.getOrDefault("upload_protocol")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "upload_protocol", valid_579035
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

proc call*(call_579037: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_579021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns `google.rpc.Code.PERMISSION_DENIED` if user does not have
  ## 'bigquery.admin' permissions on the project using the reservation
  ## and the project that owns this reservation.
  ## Returns `google.rpc.Code.INVALID_ARGUMENT` when location of the assignment
  ## does not match location of the reservation.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_579021;
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
  ## E.g.: projects/myproject/location/US/reservations/team1-prod
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579039 = newJObject()
  var query_579040 = newJObject()
  var body_579041 = newJObject()
  add(query_579040, "key", newJString(key))
  add(query_579040, "prettyPrint", newJBool(prettyPrint))
  add(query_579040, "oauth_token", newJString(oauthToken))
  add(query_579040, "$.xgafv", newJString(Xgafv))
  add(query_579040, "alt", newJString(alt))
  add(query_579040, "uploadType", newJString(uploadType))
  add(query_579040, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579041 = body
  add(query_579040, "callback", newJString(callback))
  add(path_579039, "parent", newJString(parent))
  add(query_579040, "fields", newJString(fields))
  add(query_579040, "access_token", newJString(accessToken))
  add(query_579040, "upload_protocol", newJString(uploadProtocol))
  result = call_579038.call(path_579039, query_579040, nil, nil, body_579041)

var bigqueryreservationProjectsLocationsReservationsAssignmentsCreate* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_579021(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/assignments", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_579022,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsCreate_579023,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_579000 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsAssignmentsList_579002(
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

proc validate_BigqueryreservationProjectsLocationsReservationsAssignmentsList_579001(
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
  var valid_579003 = path.getOrDefault("parent")
  valid_579003 = validateParameter(valid_579003, JString, required = true,
                                 default = nil)
  if valid_579003 != nil:
    section.add "parent", valid_579003
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
  var valid_579004 = query.getOrDefault("key")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "key", valid_579004
  var valid_579005 = query.getOrDefault("prettyPrint")
  valid_579005 = validateParameter(valid_579005, JBool, required = false,
                                 default = newJBool(true))
  if valid_579005 != nil:
    section.add "prettyPrint", valid_579005
  var valid_579006 = query.getOrDefault("oauth_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "oauth_token", valid_579006
  var valid_579007 = query.getOrDefault("$.xgafv")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("1"))
  if valid_579007 != nil:
    section.add "$.xgafv", valid_579007
  var valid_579008 = query.getOrDefault("pageSize")
  valid_579008 = validateParameter(valid_579008, JInt, required = false, default = nil)
  if valid_579008 != nil:
    section.add "pageSize", valid_579008
  var valid_579009 = query.getOrDefault("alt")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("json"))
  if valid_579009 != nil:
    section.add "alt", valid_579009
  var valid_579010 = query.getOrDefault("uploadType")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "uploadType", valid_579010
  var valid_579011 = query.getOrDefault("quotaUser")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "quotaUser", valid_579011
  var valid_579012 = query.getOrDefault("pageToken")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "pageToken", valid_579012
  var valid_579013 = query.getOrDefault("callback")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "callback", valid_579013
  var valid_579014 = query.getOrDefault("fields")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "fields", valid_579014
  var valid_579015 = query.getOrDefault("access_token")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "access_token", valid_579015
  var valid_579016 = query.getOrDefault("upload_protocol")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "upload_protocol", valid_579016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579017: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_579000;
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
  let valid = call_579017.validator(path, query, header, formData, body)
  let scheme = call_579017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579017.url(scheme.get, call_579017.host, call_579017.base,
                         call_579017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579017, url, valid)

proc call*(call_579018: Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_579000;
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
  ## projects/myproject/location/US/reservations/team1-prod
  ## Or:
  ## projects/myproject/location/US/reservations/-
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579019 = newJObject()
  var query_579020 = newJObject()
  add(query_579020, "key", newJString(key))
  add(query_579020, "prettyPrint", newJBool(prettyPrint))
  add(query_579020, "oauth_token", newJString(oauthToken))
  add(query_579020, "$.xgafv", newJString(Xgafv))
  add(query_579020, "pageSize", newJInt(pageSize))
  add(query_579020, "alt", newJString(alt))
  add(query_579020, "uploadType", newJString(uploadType))
  add(query_579020, "quotaUser", newJString(quotaUser))
  add(query_579020, "pageToken", newJString(pageToken))
  add(query_579020, "callback", newJString(callback))
  add(path_579019, "parent", newJString(parent))
  add(query_579020, "fields", newJString(fields))
  add(query_579020, "access_token", newJString(accessToken))
  add(query_579020, "upload_protocol", newJString(uploadProtocol))
  result = call_579018.call(path_579019, query_579020, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsAssignmentsList* = Call_BigqueryreservationProjectsLocationsReservationsAssignmentsList_579000(
    name: "bigqueryreservationProjectsLocationsReservationsAssignmentsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/assignments", validator: validate_BigqueryreservationProjectsLocationsReservationsAssignmentsList_579001,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsReservationsAssignmentsList_579002,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_579042 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsCapacityCommitmentsList_579044(
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

proc validate_BigqueryreservationProjectsLocationsCapacityCommitmentsList_579043(
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
  var valid_579045 = path.getOrDefault("parent")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "parent", valid_579045
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
  var valid_579046 = query.getOrDefault("key")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "key", valid_579046
  var valid_579047 = query.getOrDefault("prettyPrint")
  valid_579047 = validateParameter(valid_579047, JBool, required = false,
                                 default = newJBool(true))
  if valid_579047 != nil:
    section.add "prettyPrint", valid_579047
  var valid_579048 = query.getOrDefault("oauth_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "oauth_token", valid_579048
  var valid_579049 = query.getOrDefault("$.xgafv")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = newJString("1"))
  if valid_579049 != nil:
    section.add "$.xgafv", valid_579049
  var valid_579050 = query.getOrDefault("pageSize")
  valid_579050 = validateParameter(valid_579050, JInt, required = false, default = nil)
  if valid_579050 != nil:
    section.add "pageSize", valid_579050
  var valid_579051 = query.getOrDefault("alt")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("json"))
  if valid_579051 != nil:
    section.add "alt", valid_579051
  var valid_579052 = query.getOrDefault("uploadType")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "uploadType", valid_579052
  var valid_579053 = query.getOrDefault("quotaUser")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "quotaUser", valid_579053
  var valid_579054 = query.getOrDefault("pageToken")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "pageToken", valid_579054
  var valid_579055 = query.getOrDefault("callback")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "callback", valid_579055
  var valid_579056 = query.getOrDefault("fields")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "fields", valid_579056
  var valid_579057 = query.getOrDefault("access_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "access_token", valid_579057
  var valid_579058 = query.getOrDefault("upload_protocol")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "upload_protocol", valid_579058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579059: Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_579042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the capacity commitments for the admin project.
  ## 
  let valid = call_579059.validator(path, query, header, formData, body)
  let scheme = call_579059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579059.url(scheme.get, call_579059.host, call_579059.base,
                         call_579059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579059, url, valid)

proc call*(call_579060: Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_579042;
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
  var path_579061 = newJObject()
  var query_579062 = newJObject()
  add(query_579062, "key", newJString(key))
  add(query_579062, "prettyPrint", newJBool(prettyPrint))
  add(query_579062, "oauth_token", newJString(oauthToken))
  add(query_579062, "$.xgafv", newJString(Xgafv))
  add(query_579062, "pageSize", newJInt(pageSize))
  add(query_579062, "alt", newJString(alt))
  add(query_579062, "uploadType", newJString(uploadType))
  add(query_579062, "quotaUser", newJString(quotaUser))
  add(query_579062, "pageToken", newJString(pageToken))
  add(query_579062, "callback", newJString(callback))
  add(path_579061, "parent", newJString(parent))
  add(query_579062, "fields", newJString(fields))
  add(query_579062, "access_token", newJString(accessToken))
  add(query_579062, "upload_protocol", newJString(uploadProtocol))
  result = call_579060.call(path_579061, query_579062, nil, nil, nil)

var bigqueryreservationProjectsLocationsCapacityCommitmentsList* = Call_BigqueryreservationProjectsLocationsCapacityCommitmentsList_579042(
    name: "bigqueryreservationProjectsLocationsCapacityCommitmentsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/capacityCommitments", validator: validate_BigqueryreservationProjectsLocationsCapacityCommitmentsList_579043,
    base: "/",
    url: url_BigqueryreservationProjectsLocationsCapacityCommitmentsList_579044,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsCreate_579085 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsCreate_579087(
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

proc validate_BigqueryreservationProjectsLocationsReservationsCreate_579086(
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
  var valid_579088 = path.getOrDefault("parent")
  valid_579088 = validateParameter(valid_579088, JString, required = true,
                                 default = nil)
  if valid_579088 != nil:
    section.add "parent", valid_579088
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
  ##                : The reservation ID. This field must only contain alphanumeric characters or
  ## dash.
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
  var valid_579089 = query.getOrDefault("key")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "key", valid_579089
  var valid_579090 = query.getOrDefault("prettyPrint")
  valid_579090 = validateParameter(valid_579090, JBool, required = false,
                                 default = newJBool(true))
  if valid_579090 != nil:
    section.add "prettyPrint", valid_579090
  var valid_579091 = query.getOrDefault("oauth_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "oauth_token", valid_579091
  var valid_579092 = query.getOrDefault("$.xgafv")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("1"))
  if valid_579092 != nil:
    section.add "$.xgafv", valid_579092
  var valid_579093 = query.getOrDefault("reservationId")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "reservationId", valid_579093
  var valid_579094 = query.getOrDefault("alt")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("json"))
  if valid_579094 != nil:
    section.add "alt", valid_579094
  var valid_579095 = query.getOrDefault("uploadType")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "uploadType", valid_579095
  var valid_579096 = query.getOrDefault("quotaUser")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "quotaUser", valid_579096
  var valid_579097 = query.getOrDefault("callback")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "callback", valid_579097
  var valid_579098 = query.getOrDefault("fields")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "fields", valid_579098
  var valid_579099 = query.getOrDefault("access_token")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "access_token", valid_579099
  var valid_579100 = query.getOrDefault("upload_protocol")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "upload_protocol", valid_579100
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

proc call*(call_579102: Call_BigqueryreservationProjectsLocationsReservationsCreate_579085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new reservation resource.
  ## 
  let valid = call_579102.validator(path, query, header, formData, body)
  let scheme = call_579102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579102.url(scheme.get, call_579102.host, call_579102.base,
                         call_579102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579102, url, valid)

proc call*(call_579103: Call_BigqueryreservationProjectsLocationsReservationsCreate_579085;
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
  ##                : The reservation ID. This field must only contain alphanumeric characters or
  ## dash.
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
  var path_579104 = newJObject()
  var query_579105 = newJObject()
  var body_579106 = newJObject()
  add(query_579105, "key", newJString(key))
  add(query_579105, "prettyPrint", newJBool(prettyPrint))
  add(query_579105, "oauth_token", newJString(oauthToken))
  add(query_579105, "$.xgafv", newJString(Xgafv))
  add(query_579105, "reservationId", newJString(reservationId))
  add(query_579105, "alt", newJString(alt))
  add(query_579105, "uploadType", newJString(uploadType))
  add(query_579105, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579106 = body
  add(query_579105, "callback", newJString(callback))
  add(path_579104, "parent", newJString(parent))
  add(query_579105, "fields", newJString(fields))
  add(query_579105, "access_token", newJString(accessToken))
  add(query_579105, "upload_protocol", newJString(uploadProtocol))
  result = call_579103.call(path_579104, query_579105, nil, nil, body_579106)

var bigqueryreservationProjectsLocationsReservationsCreate* = Call_BigqueryreservationProjectsLocationsReservationsCreate_579085(
    name: "bigqueryreservationProjectsLocationsReservationsCreate",
    meth: HttpMethod.HttpPost, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsCreate_579086,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsCreate_579087,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsReservationsList_579063 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsReservationsList_579065(
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

proc validate_BigqueryreservationProjectsLocationsReservationsList_579064(
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
  var valid_579066 = path.getOrDefault("parent")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = nil)
  if valid_579066 != nil:
    section.add "parent", valid_579066
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
  var valid_579067 = query.getOrDefault("key")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "key", valid_579067
  var valid_579068 = query.getOrDefault("prettyPrint")
  valid_579068 = validateParameter(valid_579068, JBool, required = false,
                                 default = newJBool(true))
  if valid_579068 != nil:
    section.add "prettyPrint", valid_579068
  var valid_579069 = query.getOrDefault("oauth_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "oauth_token", valid_579069
  var valid_579070 = query.getOrDefault("$.xgafv")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("1"))
  if valid_579070 != nil:
    section.add "$.xgafv", valid_579070
  var valid_579071 = query.getOrDefault("pageSize")
  valid_579071 = validateParameter(valid_579071, JInt, required = false, default = nil)
  if valid_579071 != nil:
    section.add "pageSize", valid_579071
  var valid_579072 = query.getOrDefault("alt")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = newJString("json"))
  if valid_579072 != nil:
    section.add "alt", valid_579072
  var valid_579073 = query.getOrDefault("uploadType")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "uploadType", valid_579073
  var valid_579074 = query.getOrDefault("quotaUser")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "quotaUser", valid_579074
  var valid_579075 = query.getOrDefault("filter")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "filter", valid_579075
  var valid_579076 = query.getOrDefault("pageToken")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "pageToken", valid_579076
  var valid_579077 = query.getOrDefault("callback")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "callback", valid_579077
  var valid_579078 = query.getOrDefault("fields")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "fields", valid_579078
  var valid_579079 = query.getOrDefault("access_token")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "access_token", valid_579079
  var valid_579080 = query.getOrDefault("upload_protocol")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "upload_protocol", valid_579080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579081: Call_BigqueryreservationProjectsLocationsReservationsList_579063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the reservations for the project in the specified location.
  ## 
  let valid = call_579081.validator(path, query, header, formData, body)
  let scheme = call_579081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579081.url(scheme.get, call_579081.host, call_579081.base,
                         call_579081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579081, url, valid)

proc call*(call_579082: Call_BigqueryreservationProjectsLocationsReservationsList_579063;
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
  var path_579083 = newJObject()
  var query_579084 = newJObject()
  add(query_579084, "key", newJString(key))
  add(query_579084, "prettyPrint", newJBool(prettyPrint))
  add(query_579084, "oauth_token", newJString(oauthToken))
  add(query_579084, "$.xgafv", newJString(Xgafv))
  add(query_579084, "pageSize", newJInt(pageSize))
  add(query_579084, "alt", newJString(alt))
  add(query_579084, "uploadType", newJString(uploadType))
  add(query_579084, "quotaUser", newJString(quotaUser))
  add(query_579084, "filter", newJString(filter))
  add(query_579084, "pageToken", newJString(pageToken))
  add(query_579084, "callback", newJString(callback))
  add(path_579083, "parent", newJString(parent))
  add(query_579084, "fields", newJString(fields))
  add(query_579084, "access_token", newJString(accessToken))
  add(query_579084, "upload_protocol", newJString(uploadProtocol))
  result = call_579082.call(path_579083, query_579084, nil, nil, nil)

var bigqueryreservationProjectsLocationsReservationsList* = Call_BigqueryreservationProjectsLocationsReservationsList_579063(
    name: "bigqueryreservationProjectsLocationsReservationsList",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}/reservations",
    validator: validate_BigqueryreservationProjectsLocationsReservationsList_579064,
    base: "/", url: url_BigqueryreservationProjectsLocationsReservationsList_579065,
    schemes: {Scheme.Https})
type
  Call_BigqueryreservationProjectsLocationsSearchAssignments_579107 = ref object of OpenApiRestCall_578339
proc url_BigqueryreservationProjectsLocationsSearchAssignments_579109(
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

proc validate_BigqueryreservationProjectsLocationsSearchAssignments_579108(
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
  var valid_579110 = path.getOrDefault("parent")
  valid_579110 = validateParameter(valid_579110, JString, required = true,
                                 default = nil)
  if valid_579110 != nil:
    section.add "parent", valid_579110
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
  var valid_579111 = query.getOrDefault("key")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "key", valid_579111
  var valid_579112 = query.getOrDefault("prettyPrint")
  valid_579112 = validateParameter(valid_579112, JBool, required = false,
                                 default = newJBool(true))
  if valid_579112 != nil:
    section.add "prettyPrint", valid_579112
  var valid_579113 = query.getOrDefault("oauth_token")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "oauth_token", valid_579113
  var valid_579114 = query.getOrDefault("$.xgafv")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = newJString("1"))
  if valid_579114 != nil:
    section.add "$.xgafv", valid_579114
  var valid_579115 = query.getOrDefault("pageSize")
  valid_579115 = validateParameter(valid_579115, JInt, required = false, default = nil)
  if valid_579115 != nil:
    section.add "pageSize", valid_579115
  var valid_579116 = query.getOrDefault("alt")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = newJString("json"))
  if valid_579116 != nil:
    section.add "alt", valid_579116
  var valid_579117 = query.getOrDefault("uploadType")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "uploadType", valid_579117
  var valid_579118 = query.getOrDefault("quotaUser")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "quotaUser", valid_579118
  var valid_579119 = query.getOrDefault("pageToken")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "pageToken", valid_579119
  var valid_579120 = query.getOrDefault("query")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "query", valid_579120
  var valid_579121 = query.getOrDefault("callback")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "callback", valid_579121
  var valid_579122 = query.getOrDefault("fields")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "fields", valid_579122
  var valid_579123 = query.getOrDefault("access_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "access_token", valid_579123
  var valid_579124 = query.getOrDefault("upload_protocol")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "upload_protocol", valid_579124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579125: Call_BigqueryreservationProjectsLocationsSearchAssignments_579107;
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
  let valid = call_579125.validator(path, query, header, formData, body)
  let scheme = call_579125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579125.url(scheme.get, call_579125.host, call_579125.base,
                         call_579125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579125, url, valid)

proc call*(call_579126: Call_BigqueryreservationProjectsLocationsSearchAssignments_579107;
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
  ## Wildcard "-" can be used for projects in
  ## SearchAssignmentsRequest.parent. Note "-" cannot be used for projects
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
  var path_579127 = newJObject()
  var query_579128 = newJObject()
  add(query_579128, "key", newJString(key))
  add(query_579128, "prettyPrint", newJBool(prettyPrint))
  add(query_579128, "oauth_token", newJString(oauthToken))
  add(query_579128, "$.xgafv", newJString(Xgafv))
  add(query_579128, "pageSize", newJInt(pageSize))
  add(query_579128, "alt", newJString(alt))
  add(query_579128, "uploadType", newJString(uploadType))
  add(query_579128, "quotaUser", newJString(quotaUser))
  add(query_579128, "pageToken", newJString(pageToken))
  add(query_579128, "query", newJString(query))
  add(query_579128, "callback", newJString(callback))
  add(path_579127, "parent", newJString(parent))
  add(query_579128, "fields", newJString(fields))
  add(query_579128, "access_token", newJString(accessToken))
  add(query_579128, "upload_protocol", newJString(uploadProtocol))
  result = call_579126.call(path_579127, query_579128, nil, nil, nil)

var bigqueryreservationProjectsLocationsSearchAssignments* = Call_BigqueryreservationProjectsLocationsSearchAssignments_579107(
    name: "bigqueryreservationProjectsLocationsSearchAssignments",
    meth: HttpMethod.HttpGet, host: "bigqueryreservation.googleapis.com",
    route: "/v1beta1/{parent}:searchAssignments",
    validator: validate_BigqueryreservationProjectsLocationsSearchAssignments_579108,
    base: "/", url: url_BigqueryreservationProjectsLocationsSearchAssignments_579109,
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
