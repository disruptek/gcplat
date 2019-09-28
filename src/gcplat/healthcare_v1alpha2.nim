
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Healthcare
## version: v1alpha2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manage, store, and access healthcare data in Google Cloud Platform.
## 
## https://cloud.google.com/healthcare
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "healthcare"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579979 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579981(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579980(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the entire contents of a resource.
  ## 
  ## Implements the FHIR standard [update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#update).
  ## 
  ## If the specified resource does
  ## not exist and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`. The resource
  ## must contain an `id` element having an identical value to the ID in the
  ## REST path of the request.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the resource to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579982 = path.getOrDefault("name")
  valid_579982 = validateParameter(valid_579982, JString, required = true,
                                 default = nil)
  if valid_579982 != nil:
    section.add "name", valid_579982
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
  var valid_579983 = query.getOrDefault("upload_protocol")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "upload_protocol", valid_579983
  var valid_579984 = query.getOrDefault("fields")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "fields", valid_579984
  var valid_579985 = query.getOrDefault("quotaUser")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "quotaUser", valid_579985
  var valid_579986 = query.getOrDefault("alt")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("json"))
  if valid_579986 != nil:
    section.add "alt", valid_579986
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("callback")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "callback", valid_579988
  var valid_579989 = query.getOrDefault("access_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "access_token", valid_579989
  var valid_579990 = query.getOrDefault("uploadType")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "uploadType", valid_579990
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("$.xgafv")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("1"))
  if valid_579992 != nil:
    section.add "$.xgafv", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
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

proc call*(call_579995: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the entire contents of a resource.
  ## 
  ## Implements the FHIR standard [update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#update).
  ## 
  ## If the specified resource does
  ## not exist and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`. The resource
  ## must contain an `id` element having an identical value to the ID in the
  ## REST path of the request.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579979;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirUpdate
  ## Updates the entire contents of a resource.
  ## 
  ## Implements the FHIR standard [update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#update).
  ## 
  ## If the specified resource does
  ## not exist and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`. The resource
  ## must contain an `id` element having an identical value to the ID in the
  ## REST path of the request.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to update.
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
  var path_579997 = newJObject()
  var query_579998 = newJObject()
  var body_579999 = newJObject()
  add(query_579998, "upload_protocol", newJString(uploadProtocol))
  add(query_579998, "fields", newJString(fields))
  add(query_579998, "quotaUser", newJString(quotaUser))
  add(path_579997, "name", newJString(name))
  add(query_579998, "alt", newJString(alt))
  add(query_579998, "oauth_token", newJString(oauthToken))
  add(query_579998, "callback", newJString(callback))
  add(query_579998, "access_token", newJString(accessToken))
  add(query_579998, "uploadType", newJString(uploadType))
  add(query_579998, "key", newJString(key))
  add(query_579998, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579999 = body
  add(query_579998, "prettyPrint", newJBool(prettyPrint))
  result = call_579996.call(path_579997, query_579998, nil, nil, body_579999)

var healthcareProjectsLocationsDatasetsFhirStoresFhirUpdate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579979(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirUpdate",
    meth: HttpMethod.HttpPut, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579980,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579981,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresGet_579690 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresGet_579692(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresGet_579691(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the specified DICOM store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the DICOM store to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579818 = path.getOrDefault("name")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "name", valid_579818
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Specifies which parts of the Message resource should be returned
  ## in the response.
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
  var valid_579819 = query.getOrDefault("upload_protocol")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "upload_protocol", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579834 = query.getOrDefault("view")
  valid_579834 = validateParameter(valid_579834, JString, required = false, default = newJString(
      "MESSAGE_VIEW_UNSPECIFIED"))
  if valid_579834 != nil:
    section.add "view", valid_579834
  var valid_579835 = query.getOrDefault("quotaUser")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "quotaUser", valid_579835
  var valid_579836 = query.getOrDefault("alt")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = newJString("json"))
  if valid_579836 != nil:
    section.add "alt", valid_579836
  var valid_579837 = query.getOrDefault("oauth_token")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "oauth_token", valid_579837
  var valid_579838 = query.getOrDefault("callback")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "callback", valid_579838
  var valid_579839 = query.getOrDefault("access_token")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "access_token", valid_579839
  var valid_579840 = query.getOrDefault("uploadType")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "uploadType", valid_579840
  var valid_579841 = query.getOrDefault("key")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "key", valid_579841
  var valid_579842 = query.getOrDefault("$.xgafv")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = newJString("1"))
  if valid_579842 != nil:
    section.add "$.xgafv", valid_579842
  var valid_579843 = query.getOrDefault("prettyPrint")
  valid_579843 = validateParameter(valid_579843, JBool, required = false,
                                 default = newJBool(true))
  if valid_579843 != nil:
    section.add "prettyPrint", valid_579843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579866: Call_HealthcareProjectsLocationsDatasetsDicomStoresGet_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified DICOM store.
  ## 
  let valid = call_579866.validator(path, query, header, formData, body)
  let scheme = call_579866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579866.url(scheme.get, call_579866.host, call_579866.base,
                         call_579866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579866, url, valid)

proc call*(call_579937: Call_HealthcareProjectsLocationsDatasetsDicomStoresGet_579690;
          name: string; uploadProtocol: string = ""; fields: string = "";
          view: string = "MESSAGE_VIEW_UNSPECIFIED"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresGet
  ## Gets the specified DICOM store.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Specifies which parts of the Message resource should be returned
  ## in the response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the DICOM store to get.
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
  var path_579938 = newJObject()
  var query_579940 = newJObject()
  add(query_579940, "upload_protocol", newJString(uploadProtocol))
  add(query_579940, "fields", newJString(fields))
  add(query_579940, "view", newJString(view))
  add(query_579940, "quotaUser", newJString(quotaUser))
  add(path_579938, "name", newJString(name))
  add(query_579940, "alt", newJString(alt))
  add(query_579940, "oauth_token", newJString(oauthToken))
  add(query_579940, "callback", newJString(callback))
  add(query_579940, "access_token", newJString(accessToken))
  add(query_579940, "uploadType", newJString(uploadType))
  add(query_579940, "key", newJString(key))
  add(query_579940, "$.xgafv", newJString(Xgafv))
  add(query_579940, "prettyPrint", newJBool(prettyPrint))
  result = call_579937.call(path_579938, query_579940, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresGet* = Call_HealthcareProjectsLocationsDatasetsDicomStoresGet_579690(
    name: "healthcareProjectsLocationsDatasetsDicomStoresGet",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresGet_579691,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresGet_579692,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresPatch_580019 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresPatch_580021(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresPatch_580020(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the specified DICOM store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. Resource name of the DICOM store, of the form
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580022 = path.getOrDefault("name")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "name", valid_580022
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
  ##             : The update mask applies to the resource. For the `FieldMask` definition,
  ## see
  ## 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#fieldmask
  section = newJObject()
  var valid_580023 = query.getOrDefault("upload_protocol")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "upload_protocol", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("quotaUser")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "quotaUser", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  var valid_580028 = query.getOrDefault("callback")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "callback", valid_580028
  var valid_580029 = query.getOrDefault("access_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "access_token", valid_580029
  var valid_580030 = query.getOrDefault("uploadType")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "uploadType", valid_580030
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("$.xgafv")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("1"))
  if valid_580032 != nil:
    section.add "$.xgafv", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
  var valid_580034 = query.getOrDefault("updateMask")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "updateMask", valid_580034
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

proc call*(call_580036: Call_HealthcareProjectsLocationsDatasetsDicomStoresPatch_580019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified DICOM store.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_HealthcareProjectsLocationsDatasetsDicomStoresPatch_580019;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresPatch
  ## Updates the specified DICOM store.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. Resource name of the DICOM store, of the form
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`.
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
  ##             : The update mask applies to the resource. For the `FieldMask` definition,
  ## see
  ## 
  ## https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#fieldmask
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  var body_580040 = newJObject()
  add(query_580039, "upload_protocol", newJString(uploadProtocol))
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(path_580038, "name", newJString(name))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "callback", newJString(callback))
  add(query_580039, "access_token", newJString(accessToken))
  add(query_580039, "uploadType", newJString(uploadType))
  add(query_580039, "key", newJString(key))
  add(query_580039, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580040 = body
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  add(query_580039, "updateMask", newJString(updateMask))
  result = call_580037.call(path_580038, query_580039, nil, nil, body_580040)

var healthcareProjectsLocationsDatasetsDicomStoresPatch* = Call_HealthcareProjectsLocationsDatasetsDicomStoresPatch_580019(
    name: "healthcareProjectsLocationsDatasetsDicomStoresPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresPatch_580020,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresPatch_580021,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresDelete_580000 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresDelete_580002(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresDelete_580001(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified DICOM store and removes all images that are contained
  ## within it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the DICOM store to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580003 = path.getOrDefault("name")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "name", valid_580003
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
  var valid_580004 = query.getOrDefault("upload_protocol")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "upload_protocol", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("quotaUser")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "quotaUser", valid_580006
  var valid_580007 = query.getOrDefault("alt")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("json"))
  if valid_580007 != nil:
    section.add "alt", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("callback")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "callback", valid_580009
  var valid_580010 = query.getOrDefault("access_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "access_token", valid_580010
  var valid_580011 = query.getOrDefault("uploadType")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "uploadType", valid_580011
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("$.xgafv")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("1"))
  if valid_580013 != nil:
    section.add "$.xgafv", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(true))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580015: Call_HealthcareProjectsLocationsDatasetsDicomStoresDelete_580000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified DICOM store and removes all images that are contained
  ## within it.
  ## 
  let valid = call_580015.validator(path, query, header, formData, body)
  let scheme = call_580015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580015.url(scheme.get, call_580015.host, call_580015.base,
                         call_580015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580015, url, valid)

proc call*(call_580016: Call_HealthcareProjectsLocationsDatasetsDicomStoresDelete_580000;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresDelete
  ## Deletes the specified DICOM store and removes all images that are contained
  ## within it.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the DICOM store to delete.
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
  var path_580017 = newJObject()
  var query_580018 = newJObject()
  add(query_580018, "upload_protocol", newJString(uploadProtocol))
  add(query_580018, "fields", newJString(fields))
  add(query_580018, "quotaUser", newJString(quotaUser))
  add(path_580017, "name", newJString(name))
  add(query_580018, "alt", newJString(alt))
  add(query_580018, "oauth_token", newJString(oauthToken))
  add(query_580018, "callback", newJString(callback))
  add(query_580018, "access_token", newJString(accessToken))
  add(query_580018, "uploadType", newJString(uploadType))
  add(query_580018, "key", newJString(key))
  add(query_580018, "$.xgafv", newJString(Xgafv))
  add(query_580018, "prettyPrint", newJBool(prettyPrint))
  result = call_580016.call(path_580017, query_580018, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresDelete* = Call_HealthcareProjectsLocationsDatasetsDicomStoresDelete_580000(
    name: "healthcareProjectsLocationsDatasetsDicomStoresDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresDelete_580001,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresDelete_580002,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_580041 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_580043(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/$everything")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_580042(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves all the resources directly referenced by a patient, as well as
  ## all of the resources in the patient compartment.
  ## 
  ## Implements the FHIR extended operation
  ## [Patient-everything](http://hl7.org/implement/standards/fhir/STU3/patient-operations.html#everything).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the `Patient` resource for which the information is required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580044 = path.getOrDefault("name")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "name", valid_580044
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Used to retrieve the next or previous page of results
  ## when using pagination. Value should be set to the value of page_token set
  ## in next or previous page links' url. Next and previous page are returned
  ## in the response bundle's links field, where `link.relation` is "previous"
  ## or "next".
  ## 
  ## Omit `page_token` if no previous request has been made.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   _count: JInt
  ##         : Maximum number of resources in a page. Defaults to 100.
  ##   end: JString
  ##      : The response includes records prior to the end date. If no end date is
  ## provided, all records subsequent to the start date are in scope.
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
  ##   start: JString
  ##        : The response includes records subsequent to the start date. If no start
  ## date is provided, all records prior to the end date are in scope.
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
  var valid_580047 = query.getOrDefault("pageToken")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "pageToken", valid_580047
  var valid_580048 = query.getOrDefault("quotaUser")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "quotaUser", valid_580048
  var valid_580049 = query.getOrDefault("alt")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = newJString("json"))
  if valid_580049 != nil:
    section.add "alt", valid_580049
  var valid_580050 = query.getOrDefault("_count")
  valid_580050 = validateParameter(valid_580050, JInt, required = false, default = nil)
  if valid_580050 != nil:
    section.add "_count", valid_580050
  var valid_580051 = query.getOrDefault("end")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "end", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("callback")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "callback", valid_580053
  var valid_580054 = query.getOrDefault("access_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "access_token", valid_580054
  var valid_580055 = query.getOrDefault("uploadType")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "uploadType", valid_580055
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("$.xgafv")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("1"))
  if valid_580057 != nil:
    section.add "$.xgafv", valid_580057
  var valid_580058 = query.getOrDefault("prettyPrint")
  valid_580058 = validateParameter(valid_580058, JBool, required = false,
                                 default = newJBool(true))
  if valid_580058 != nil:
    section.add "prettyPrint", valid_580058
  var valid_580059 = query.getOrDefault("start")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "start", valid_580059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580060: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_580041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all the resources directly referenced by a patient, as well as
  ## all of the resources in the patient compartment.
  ## 
  ## Implements the FHIR extended operation
  ## [Patient-everything](http://hl7.org/implement/standards/fhir/STU3/patient-operations.html#everything).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_580060.validator(path, query, header, formData, body)
  let scheme = call_580060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580060.url(scheme.get, call_580060.host, call_580060.base,
                         call_580060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580060, url, valid)

proc call*(call_580061: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_580041;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          Count: int = 0; `end`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          start: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything
  ## Retrieves all the resources directly referenced by a patient, as well as
  ## all of the resources in the patient compartment.
  ## 
  ## Implements the FHIR extended operation
  ## [Patient-everything](http://hl7.org/implement/standards/fhir/STU3/patient-operations.html#everything).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Used to retrieve the next or previous page of results
  ## when using pagination. Value should be set to the value of page_token set
  ## in next or previous page links' url. Next and previous page are returned
  ## in the response bundle's links field, where `link.relation` is "previous"
  ## or "next".
  ## 
  ## Omit `page_token` if no previous request has been made.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the `Patient` resource for which the information is required.
  ##   alt: string
  ##      : Data format for response.
  ##   Count: int
  ##        : Maximum number of resources in a page. Defaults to 100.
  ##   end: string
  ##      : The response includes records prior to the end date. If no end date is
  ## provided, all records subsequent to the start date are in scope.
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
  ##   start: string
  ##        : The response includes records subsequent to the start date. If no start
  ## date is provided, all records prior to the end date are in scope.
  var path_580062 = newJObject()
  var query_580063 = newJObject()
  add(query_580063, "upload_protocol", newJString(uploadProtocol))
  add(query_580063, "fields", newJString(fields))
  add(query_580063, "pageToken", newJString(pageToken))
  add(query_580063, "quotaUser", newJString(quotaUser))
  add(path_580062, "name", newJString(name))
  add(query_580063, "alt", newJString(alt))
  add(query_580063, "_count", newJInt(Count))
  add(query_580063, "end", newJString(`end`))
  add(query_580063, "oauth_token", newJString(oauthToken))
  add(query_580063, "callback", newJString(callback))
  add(query_580063, "access_token", newJString(accessToken))
  add(query_580063, "uploadType", newJString(uploadType))
  add(query_580063, "key", newJString(key))
  add(query_580063, "$.xgafv", newJString(Xgafv))
  add(query_580063, "prettyPrint", newJBool(prettyPrint))
  add(query_580063, "start", newJString(start))
  result = call_580061.call(path_580062, query_580063, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_580041(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/$everything", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_580042,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_580043,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_580064 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_580066(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/$purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_580065(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes all the historical versions of a resource (excluding the current
  ## version) from the FHIR store. To remove all versions of a resource, first
  ## delete the current version and then call this method.
  ## 
  ## This is not a FHIR standard operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the resource to purge.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580067 = path.getOrDefault("name")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "name", valid_580067
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
  var valid_580068 = query.getOrDefault("upload_protocol")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "upload_protocol", valid_580068
  var valid_580069 = query.getOrDefault("fields")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "fields", valid_580069
  var valid_580070 = query.getOrDefault("quotaUser")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "quotaUser", valid_580070
  var valid_580071 = query.getOrDefault("alt")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("json"))
  if valid_580071 != nil:
    section.add "alt", valid_580071
  var valid_580072 = query.getOrDefault("oauth_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "oauth_token", valid_580072
  var valid_580073 = query.getOrDefault("callback")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "callback", valid_580073
  var valid_580074 = query.getOrDefault("access_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "access_token", valid_580074
  var valid_580075 = query.getOrDefault("uploadType")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "uploadType", valid_580075
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("$.xgafv")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("1"))
  if valid_580077 != nil:
    section.add "$.xgafv", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580079: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_580064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all the historical versions of a resource (excluding the current
  ## version) from the FHIR store. To remove all versions of a resource, first
  ## delete the current version and then call this method.
  ## 
  ## This is not a FHIR standard operation.
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_580064;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge
  ## Deletes all the historical versions of a resource (excluding the current
  ## version) from the FHIR store. To remove all versions of a resource, first
  ## delete the current version and then call this method.
  ## 
  ## This is not a FHIR standard operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to purge.
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
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  add(query_580082, "upload_protocol", newJString(uploadProtocol))
  add(query_580082, "fields", newJString(fields))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(path_580081, "name", newJString(name))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(query_580082, "callback", newJString(callback))
  add(query_580082, "access_token", newJString(accessToken))
  add(query_580082, "uploadType", newJString(uploadType))
  add(query_580082, "key", newJString(key))
  add(query_580082, "$.xgafv", newJString(Xgafv))
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  result = call_580080.call(path_580081, query_580082, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_580064(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/$purge", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_580065,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_580066,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_580083 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_580085(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/_history")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_580084(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the versions of a resource (including the current version and
  ## deleted versions) from the FHIR store.
  ## 
  ## Implements the per-resource form of the FHIR standard [history
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#history).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `history`, containing the version history
  ## sorted from most recent to oldest versions.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the resource to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580086 = path.getOrDefault("name")
  valid_580086 = validateParameter(valid_580086, JString, required = true,
                                 default = nil)
  if valid_580086 != nil:
    section.add "name", valid_580086
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   at: JString
  ##     : Only include resource versions that were current at some point during the
  ## time period specified in the date time value. The date parameter format is
  ## yyyy-mm-ddThh:mm:ss[Z|(+|-)hh:mm]
  ## 
  ## Clients may specify any of the following:
  ## 
  ## *  An entire year: `_at=2019`
  ## *  An entire month: `_at=2019-01`
  ## *  A specific day: `_at=2019-01-20`
  ## *  A specific second: `_at=2018-12-31T23:59:58Z`
  ##   alt: JString
  ##      : Data format for response.
  ##   since: JString
  ##        : Only include resource versions that were created at or after the given
  ## instant in time. The instant in time uses the format
  ## YYYY-MM-DDThh:mm:ss.sss+zz:zz (for example 2015-02-07T13:28:17.239+02:00 or
  ## 2017-01-01T00:00:00Z). The time must be specified to the second and
  ## include a time zone.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   page: JString
  ##       : Used to retrieve the first, previous, next, or last page of resource
  ## versions when using pagination. Value should be set to the value of the
  ## `link.url` field returned in the response to the previous request, where
  ## `link.relation` is "first", "previous", "next" or "last".
  ## 
  ## Omit `page` if no previous request has been made.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   count: JInt
  ##        : The maximum number of search results on a page. Defaults to 1000.
  section = newJObject()
  var valid_580087 = query.getOrDefault("upload_protocol")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "upload_protocol", valid_580087
  var valid_580088 = query.getOrDefault("fields")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "fields", valid_580088
  var valid_580089 = query.getOrDefault("quotaUser")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "quotaUser", valid_580089
  var valid_580090 = query.getOrDefault("at")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "at", valid_580090
  var valid_580091 = query.getOrDefault("alt")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = newJString("json"))
  if valid_580091 != nil:
    section.add "alt", valid_580091
  var valid_580092 = query.getOrDefault("since")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "since", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("callback")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "callback", valid_580094
  var valid_580095 = query.getOrDefault("access_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "access_token", valid_580095
  var valid_580096 = query.getOrDefault("uploadType")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "uploadType", valid_580096
  var valid_580097 = query.getOrDefault("page")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "page", valid_580097
  var valid_580098 = query.getOrDefault("key")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "key", valid_580098
  var valid_580099 = query.getOrDefault("$.xgafv")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("1"))
  if valid_580099 != nil:
    section.add "$.xgafv", valid_580099
  var valid_580100 = query.getOrDefault("prettyPrint")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "prettyPrint", valid_580100
  var valid_580101 = query.getOrDefault("count")
  valid_580101 = validateParameter(valid_580101, JInt, required = false, default = nil)
  if valid_580101 != nil:
    section.add "count", valid_580101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580102: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_580083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the versions of a resource (including the current version and
  ## deleted versions) from the FHIR store.
  ## 
  ## Implements the per-resource form of the FHIR standard [history
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#history).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `history`, containing the version history
  ## sorted from most recent to oldest versions.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_580102.validator(path, query, header, formData, body)
  let scheme = call_580102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580102.url(scheme.get, call_580102.host, call_580102.base,
                         call_580102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580102, url, valid)

proc call*(call_580103: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_580083;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; at: string = ""; alt: string = "json"; since: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; page: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; count: int = 0): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirHistory
  ## Lists all the versions of a resource (including the current version and
  ## deleted versions) from the FHIR store.
  ## 
  ## Implements the per-resource form of the FHIR standard [history
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#history).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `history`, containing the version history
  ## sorted from most recent to oldest versions.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   at: string
  ##     : Only include resource versions that were current at some point during the
  ## time period specified in the date time value. The date parameter format is
  ## yyyy-mm-ddThh:mm:ss[Z|(+|-)hh:mm]
  ## 
  ## Clients may specify any of the following:
  ## 
  ## *  An entire year: `_at=2019`
  ## *  An entire month: `_at=2019-01`
  ## *  A specific day: `_at=2019-01-20`
  ## *  A specific second: `_at=2018-12-31T23:59:58Z`
  ##   name: string (required)
  ##       : The name of the resource to retrieve.
  ##   alt: string
  ##      : Data format for response.
  ##   since: string
  ##        : Only include resource versions that were created at or after the given
  ## instant in time. The instant in time uses the format
  ## YYYY-MM-DDThh:mm:ss.sss+zz:zz (for example 2015-02-07T13:28:17.239+02:00 or
  ## 2017-01-01T00:00:00Z). The time must be specified to the second and
  ## include a time zone.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   page: string
  ##       : Used to retrieve the first, previous, next, or last page of resource
  ## versions when using pagination. Value should be set to the value of the
  ## `link.url` field returned in the response to the previous request, where
  ## `link.relation` is "first", "previous", "next" or "last".
  ## 
  ## Omit `page` if no previous request has been made.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   count: int
  ##        : The maximum number of search results on a page. Defaults to 1000.
  var path_580104 = newJObject()
  var query_580105 = newJObject()
  add(query_580105, "upload_protocol", newJString(uploadProtocol))
  add(query_580105, "fields", newJString(fields))
  add(query_580105, "quotaUser", newJString(quotaUser))
  add(query_580105, "at", newJString(at))
  add(path_580104, "name", newJString(name))
  add(query_580105, "alt", newJString(alt))
  add(query_580105, "since", newJString(since))
  add(query_580105, "oauth_token", newJString(oauthToken))
  add(query_580105, "callback", newJString(callback))
  add(query_580105, "access_token", newJString(accessToken))
  add(query_580105, "uploadType", newJString(uploadType))
  add(query_580105, "page", newJString(page))
  add(query_580105, "key", newJString(key))
  add(query_580105, "$.xgafv", newJString(Xgafv))
  add(query_580105, "prettyPrint", newJBool(prettyPrint))
  add(query_580105, "count", newJInt(count))
  result = call_580103.call(path_580104, query_580105, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirHistory* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_580083(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirHistory",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/_history", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_580084,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_580085,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_580106 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_580108(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/fhir/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_580107(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the FHIR store to retrieve the capabilities for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580109 = path.getOrDefault("name")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "name", valid_580109
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
  var valid_580110 = query.getOrDefault("upload_protocol")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "upload_protocol", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("callback")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "callback", valid_580115
  var valid_580116 = query.getOrDefault("access_token")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "access_token", valid_580116
  var valid_580117 = query.getOrDefault("uploadType")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "uploadType", valid_580117
  var valid_580118 = query.getOrDefault("key")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "key", valid_580118
  var valid_580119 = query.getOrDefault("$.xgafv")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("1"))
  if valid_580119 != nil:
    section.add "$.xgafv", valid_580119
  var valid_580120 = query.getOrDefault("prettyPrint")
  valid_580120 = validateParameter(valid_580120, JBool, required = false,
                                 default = newJBool(true))
  if valid_580120 != nil:
    section.add "prettyPrint", valid_580120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580121: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_580106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ## 
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_580106;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the FHIR store to retrieve the capabilities for.
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
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  add(query_580124, "upload_protocol", newJString(uploadProtocol))
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(path_580123, "name", newJString(name))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "callback", newJString(callback))
  add(query_580124, "access_token", newJString(accessToken))
  add(query_580124, "uploadType", newJString(uploadType))
  add(query_580124, "key", newJString(key))
  add(query_580124, "$.xgafv", newJString(Xgafv))
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  result = call_580122.call(path_580123, query_580124, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_580106(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/fhir/metadata", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_580107,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_580108,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsList_580125 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsList_580127(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsList_580126(path: JsonNode;
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
  var valid_580128 = path.getOrDefault("name")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "name", valid_580128
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
  var valid_580129 = query.getOrDefault("upload_protocol")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "upload_protocol", valid_580129
  var valid_580130 = query.getOrDefault("fields")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "fields", valid_580130
  var valid_580131 = query.getOrDefault("pageToken")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "pageToken", valid_580131
  var valid_580132 = query.getOrDefault("quotaUser")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "quotaUser", valid_580132
  var valid_580133 = query.getOrDefault("alt")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("json"))
  if valid_580133 != nil:
    section.add "alt", valid_580133
  var valid_580134 = query.getOrDefault("oauth_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "oauth_token", valid_580134
  var valid_580135 = query.getOrDefault("callback")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "callback", valid_580135
  var valid_580136 = query.getOrDefault("access_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "access_token", valid_580136
  var valid_580137 = query.getOrDefault("uploadType")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "uploadType", valid_580137
  var valid_580138 = query.getOrDefault("key")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "key", valid_580138
  var valid_580139 = query.getOrDefault("$.xgafv")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = newJString("1"))
  if valid_580139 != nil:
    section.add "$.xgafv", valid_580139
  var valid_580140 = query.getOrDefault("pageSize")
  valid_580140 = validateParameter(valid_580140, JInt, required = false, default = nil)
  if valid_580140 != nil:
    section.add "pageSize", valid_580140
  var valid_580141 = query.getOrDefault("prettyPrint")
  valid_580141 = validateParameter(valid_580141, JBool, required = false,
                                 default = newJBool(true))
  if valid_580141 != nil:
    section.add "prettyPrint", valid_580141
  var valid_580142 = query.getOrDefault("filter")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "filter", valid_580142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580143: Call_HealthcareProjectsLocationsList_580125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580143.validator(path, query, header, formData, body)
  let scheme = call_580143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580143.url(scheme.get, call_580143.host, call_580143.base,
                         call_580143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580143, url, valid)

proc call*(call_580144: Call_HealthcareProjectsLocationsList_580125; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## healthcareProjectsLocationsList
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
  var path_580145 = newJObject()
  var query_580146 = newJObject()
  add(query_580146, "upload_protocol", newJString(uploadProtocol))
  add(query_580146, "fields", newJString(fields))
  add(query_580146, "pageToken", newJString(pageToken))
  add(query_580146, "quotaUser", newJString(quotaUser))
  add(path_580145, "name", newJString(name))
  add(query_580146, "alt", newJString(alt))
  add(query_580146, "oauth_token", newJString(oauthToken))
  add(query_580146, "callback", newJString(callback))
  add(query_580146, "access_token", newJString(accessToken))
  add(query_580146, "uploadType", newJString(uploadType))
  add(query_580146, "key", newJString(key))
  add(query_580146, "$.xgafv", newJString(Xgafv))
  add(query_580146, "pageSize", newJInt(pageSize))
  add(query_580146, "prettyPrint", newJBool(prettyPrint))
  add(query_580146, "filter", newJString(filter))
  result = call_580144.call(path_580145, query_580146, nil, nil, nil)

var healthcareProjectsLocationsList* = Call_HealthcareProjectsLocationsList_580125(
    name: "healthcareProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "healthcare.googleapis.com", route: "/v1alpha2/{name}/locations",
    validator: validate_HealthcareProjectsLocationsList_580126, base: "/",
    url: url_HealthcareProjectsLocationsList_580127, schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_580147 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_580149(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_580148(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the FHIR store to retrieve the capabilities for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580150 = path.getOrDefault("name")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "name", valid_580150
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
  var valid_580151 = query.getOrDefault("upload_protocol")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "upload_protocol", valid_580151
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("quotaUser")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "quotaUser", valid_580153
  var valid_580154 = query.getOrDefault("alt")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("json"))
  if valid_580154 != nil:
    section.add "alt", valid_580154
  var valid_580155 = query.getOrDefault("oauth_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "oauth_token", valid_580155
  var valid_580156 = query.getOrDefault("callback")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "callback", valid_580156
  var valid_580157 = query.getOrDefault("access_token")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "access_token", valid_580157
  var valid_580158 = query.getOrDefault("uploadType")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "uploadType", valid_580158
  var valid_580159 = query.getOrDefault("key")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "key", valid_580159
  var valid_580160 = query.getOrDefault("$.xgafv")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = newJString("1"))
  if valid_580160 != nil:
    section.add "$.xgafv", valid_580160
  var valid_580161 = query.getOrDefault("prettyPrint")
  valid_580161 = validateParameter(valid_580161, JBool, required = false,
                                 default = newJBool(true))
  if valid_580161 != nil:
    section.add "prettyPrint", valid_580161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580162: Call_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_580147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ## 
  let valid = call_580162.validator(path, query, header, formData, body)
  let scheme = call_580162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580162.url(scheme.get, call_580162.host, call_580162.base,
                         call_580162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580162, url, valid)

proc call*(call_580163: Call_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_580147;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresCapabilities
  ## Gets the FHIR [capability
  ## statement](http://hl7.org/implement/standards/fhir/STU3/capabilitystatement.html)
  ## for the store, which contains a description of functionality supported by
  ## the server.
  ## 
  ## Implements the FHIR standard [capabilities
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#capabilities).
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `CapabilityStatement` resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the FHIR store to retrieve the capabilities for.
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
  var path_580164 = newJObject()
  var query_580165 = newJObject()
  add(query_580165, "upload_protocol", newJString(uploadProtocol))
  add(query_580165, "fields", newJString(fields))
  add(query_580165, "quotaUser", newJString(quotaUser))
  add(path_580164, "name", newJString(name))
  add(query_580165, "alt", newJString(alt))
  add(query_580165, "oauth_token", newJString(oauthToken))
  add(query_580165, "callback", newJString(callback))
  add(query_580165, "access_token", newJString(accessToken))
  add(query_580165, "uploadType", newJString(uploadType))
  add(query_580165, "key", newJString(key))
  add(query_580165, "$.xgafv", newJString(Xgafv))
  add(query_580165, "prettyPrint", newJBool(prettyPrint))
  result = call_580163.call(path_580164, query_580165, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresCapabilities* = Call_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_580147(
    name: "healthcareProjectsLocationsDatasetsFhirStoresCapabilities",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/metadata", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_580148,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresCapabilities_580149,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsOperationsList_580166 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsOperationsList_580168(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsOperationsList_580167(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580169 = path.getOrDefault("name")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "name", valid_580169
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
  var valid_580172 = query.getOrDefault("pageToken")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "pageToken", valid_580172
  var valid_580173 = query.getOrDefault("quotaUser")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "quotaUser", valid_580173
  var valid_580174 = query.getOrDefault("alt")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("json"))
  if valid_580174 != nil:
    section.add "alt", valid_580174
  var valid_580175 = query.getOrDefault("oauth_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "oauth_token", valid_580175
  var valid_580176 = query.getOrDefault("callback")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "callback", valid_580176
  var valid_580177 = query.getOrDefault("access_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "access_token", valid_580177
  var valid_580178 = query.getOrDefault("uploadType")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "uploadType", valid_580178
  var valid_580179 = query.getOrDefault("key")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "key", valid_580179
  var valid_580180 = query.getOrDefault("$.xgafv")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("1"))
  if valid_580180 != nil:
    section.add "$.xgafv", valid_580180
  var valid_580181 = query.getOrDefault("pageSize")
  valid_580181 = validateParameter(valid_580181, JInt, required = false, default = nil)
  if valid_580181 != nil:
    section.add "pageSize", valid_580181
  var valid_580182 = query.getOrDefault("prettyPrint")
  valid_580182 = validateParameter(valid_580182, JBool, required = false,
                                 default = newJBool(true))
  if valid_580182 != nil:
    section.add "prettyPrint", valid_580182
  var valid_580183 = query.getOrDefault("filter")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "filter", valid_580183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580184: Call_HealthcareProjectsLocationsDatasetsOperationsList_580166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_580184.validator(path, query, header, formData, body)
  let scheme = call_580184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580184.url(scheme.get, call_580184.host, call_580184.base,
                         call_580184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580184, url, valid)

proc call*(call_580185: Call_HealthcareProjectsLocationsDatasetsOperationsList_580166;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
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
  var path_580186 = newJObject()
  var query_580187 = newJObject()
  add(query_580187, "upload_protocol", newJString(uploadProtocol))
  add(query_580187, "fields", newJString(fields))
  add(query_580187, "pageToken", newJString(pageToken))
  add(query_580187, "quotaUser", newJString(quotaUser))
  add(path_580186, "name", newJString(name))
  add(query_580187, "alt", newJString(alt))
  add(query_580187, "oauth_token", newJString(oauthToken))
  add(query_580187, "callback", newJString(callback))
  add(query_580187, "access_token", newJString(accessToken))
  add(query_580187, "uploadType", newJString(uploadType))
  add(query_580187, "key", newJString(key))
  add(query_580187, "$.xgafv", newJString(Xgafv))
  add(query_580187, "pageSize", newJInt(pageSize))
  add(query_580187, "prettyPrint", newJBool(prettyPrint))
  add(query_580187, "filter", newJString(filter))
  result = call_580185.call(path_580186, query_580187, nil, nil, nil)

var healthcareProjectsLocationsDatasetsOperationsList* = Call_HealthcareProjectsLocationsDatasetsOperationsList_580166(
    name: "healthcareProjectsLocationsDatasetsOperationsList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}/operations",
    validator: validate_HealthcareProjectsLocationsDatasetsOperationsList_580167,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsOperationsList_580168,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresExport_580188 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresExport_580190(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresExport_580189(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Exports data to the specified destination by copying it from the DICOM
  ## store.
  ## The metadata field type is
  ## OperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The DICOM store resource name from which the data should be exported (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580191 = path.getOrDefault("name")
  valid_580191 = validateParameter(valid_580191, JString, required = true,
                                 default = nil)
  if valid_580191 != nil:
    section.add "name", valid_580191
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
  var valid_580192 = query.getOrDefault("upload_protocol")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "upload_protocol", valid_580192
  var valid_580193 = query.getOrDefault("fields")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "fields", valid_580193
  var valid_580194 = query.getOrDefault("quotaUser")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "quotaUser", valid_580194
  var valid_580195 = query.getOrDefault("alt")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = newJString("json"))
  if valid_580195 != nil:
    section.add "alt", valid_580195
  var valid_580196 = query.getOrDefault("oauth_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "oauth_token", valid_580196
  var valid_580197 = query.getOrDefault("callback")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "callback", valid_580197
  var valid_580198 = query.getOrDefault("access_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "access_token", valid_580198
  var valid_580199 = query.getOrDefault("uploadType")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "uploadType", valid_580199
  var valid_580200 = query.getOrDefault("key")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "key", valid_580200
  var valid_580201 = query.getOrDefault("$.xgafv")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = newJString("1"))
  if valid_580201 != nil:
    section.add "$.xgafv", valid_580201
  var valid_580202 = query.getOrDefault("prettyPrint")
  valid_580202 = validateParameter(valid_580202, JBool, required = false,
                                 default = newJBool(true))
  if valid_580202 != nil:
    section.add "prettyPrint", valid_580202
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

proc call*(call_580204: Call_HealthcareProjectsLocationsDatasetsDicomStoresExport_580188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports data to the specified destination by copying it from the DICOM
  ## store.
  ## The metadata field type is
  ## OperationMetadata.
  ## 
  let valid = call_580204.validator(path, query, header, formData, body)
  let scheme = call_580204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580204.url(scheme.get, call_580204.host, call_580204.base,
                         call_580204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580204, url, valid)

proc call*(call_580205: Call_HealthcareProjectsLocationsDatasetsDicomStoresExport_580188;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresExport
  ## Exports data to the specified destination by copying it from the DICOM
  ## store.
  ## The metadata field type is
  ## OperationMetadata.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The DICOM store resource name from which the data should be exported (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
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
  var path_580206 = newJObject()
  var query_580207 = newJObject()
  var body_580208 = newJObject()
  add(query_580207, "upload_protocol", newJString(uploadProtocol))
  add(query_580207, "fields", newJString(fields))
  add(query_580207, "quotaUser", newJString(quotaUser))
  add(path_580206, "name", newJString(name))
  add(query_580207, "alt", newJString(alt))
  add(query_580207, "oauth_token", newJString(oauthToken))
  add(query_580207, "callback", newJString(callback))
  add(query_580207, "access_token", newJString(accessToken))
  add(query_580207, "uploadType", newJString(uploadType))
  add(query_580207, "key", newJString(key))
  add(query_580207, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580208 = body
  add(query_580207, "prettyPrint", newJBool(prettyPrint))
  result = call_580205.call(path_580206, query_580207, nil, nil, body_580208)

var healthcareProjectsLocationsDatasetsDicomStoresExport* = Call_HealthcareProjectsLocationsDatasetsDicomStoresExport_580188(
    name: "healthcareProjectsLocationsDatasetsDicomStoresExport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}:export",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresExport_580189,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresExport_580190,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresImport_580209 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresImport_580211(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresImport_580210(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Imports data into the DICOM store by copying it from the specified source.
  ## For errors, the Operation will be populated with error details (in the form
  ## of ImportDicomDataErrorDetails in error.details), which will hold
  ## finer-grained error information. Errors are also logged to Stackdriver
  ## (see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## The metadata field type is
  ## OperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the DICOM store resource into which the data is imported (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580212 = path.getOrDefault("name")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "name", valid_580212
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
  var valid_580213 = query.getOrDefault("upload_protocol")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "upload_protocol", valid_580213
  var valid_580214 = query.getOrDefault("fields")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "fields", valid_580214
  var valid_580215 = query.getOrDefault("quotaUser")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "quotaUser", valid_580215
  var valid_580216 = query.getOrDefault("alt")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = newJString("json"))
  if valid_580216 != nil:
    section.add "alt", valid_580216
  var valid_580217 = query.getOrDefault("oauth_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "oauth_token", valid_580217
  var valid_580218 = query.getOrDefault("callback")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "callback", valid_580218
  var valid_580219 = query.getOrDefault("access_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "access_token", valid_580219
  var valid_580220 = query.getOrDefault("uploadType")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "uploadType", valid_580220
  var valid_580221 = query.getOrDefault("key")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "key", valid_580221
  var valid_580222 = query.getOrDefault("$.xgafv")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("1"))
  if valid_580222 != nil:
    section.add "$.xgafv", valid_580222
  var valid_580223 = query.getOrDefault("prettyPrint")
  valid_580223 = validateParameter(valid_580223, JBool, required = false,
                                 default = newJBool(true))
  if valid_580223 != nil:
    section.add "prettyPrint", valid_580223
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

proc call*(call_580225: Call_HealthcareProjectsLocationsDatasetsDicomStoresImport_580209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports data into the DICOM store by copying it from the specified source.
  ## For errors, the Operation will be populated with error details (in the form
  ## of ImportDicomDataErrorDetails in error.details), which will hold
  ## finer-grained error information. Errors are also logged to Stackdriver
  ## (see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## The metadata field type is
  ## OperationMetadata.
  ## 
  let valid = call_580225.validator(path, query, header, formData, body)
  let scheme = call_580225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580225.url(scheme.get, call_580225.host, call_580225.base,
                         call_580225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580225, url, valid)

proc call*(call_580226: Call_HealthcareProjectsLocationsDatasetsDicomStoresImport_580209;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresImport
  ## Imports data into the DICOM store by copying it from the specified source.
  ## For errors, the Operation will be populated with error details (in the form
  ## of ImportDicomDataErrorDetails in error.details), which will hold
  ## finer-grained error information. Errors are also logged to Stackdriver
  ## (see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## The metadata field type is
  ## OperationMetadata.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the DICOM store resource into which the data is imported (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
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
  var path_580227 = newJObject()
  var query_580228 = newJObject()
  var body_580229 = newJObject()
  add(query_580228, "upload_protocol", newJString(uploadProtocol))
  add(query_580228, "fields", newJString(fields))
  add(query_580228, "quotaUser", newJString(quotaUser))
  add(path_580227, "name", newJString(name))
  add(query_580228, "alt", newJString(alt))
  add(query_580228, "oauth_token", newJString(oauthToken))
  add(query_580228, "callback", newJString(callback))
  add(query_580228, "access_token", newJString(accessToken))
  add(query_580228, "uploadType", newJString(uploadType))
  add(query_580228, "key", newJString(key))
  add(query_580228, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580229 = body
  add(query_580228, "prettyPrint", newJBool(prettyPrint))
  result = call_580226.call(path_580227, query_580228, nil, nil, body_580229)

var healthcareProjectsLocationsDatasetsDicomStoresImport* = Call_HealthcareProjectsLocationsDatasetsDicomStoresImport_580209(
    name: "healthcareProjectsLocationsDatasetsDicomStoresImport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{name}:import",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresImport_580210,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresImport_580211,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_580252 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_580254(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/annotationStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_580253(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new Annotation store within the parent dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this Annotation store belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580255 = path.getOrDefault("parent")
  valid_580255 = validateParameter(valid_580255, JString, required = true,
                                 default = nil)
  if valid_580255 != nil:
    section.add "parent", valid_580255
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
  ##   annotationStoreId: JString
  ##                    : The ID of the Annotation store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580256 = query.getOrDefault("upload_protocol")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "upload_protocol", valid_580256
  var valid_580257 = query.getOrDefault("fields")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "fields", valid_580257
  var valid_580258 = query.getOrDefault("quotaUser")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "quotaUser", valid_580258
  var valid_580259 = query.getOrDefault("alt")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = newJString("json"))
  if valid_580259 != nil:
    section.add "alt", valid_580259
  var valid_580260 = query.getOrDefault("oauth_token")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "oauth_token", valid_580260
  var valid_580261 = query.getOrDefault("callback")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "callback", valid_580261
  var valid_580262 = query.getOrDefault("access_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "access_token", valid_580262
  var valid_580263 = query.getOrDefault("uploadType")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "uploadType", valid_580263
  var valid_580264 = query.getOrDefault("key")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "key", valid_580264
  var valid_580265 = query.getOrDefault("$.xgafv")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = newJString("1"))
  if valid_580265 != nil:
    section.add "$.xgafv", valid_580265
  var valid_580266 = query.getOrDefault("annotationStoreId")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "annotationStoreId", valid_580266
  var valid_580267 = query.getOrDefault("prettyPrint")
  valid_580267 = validateParameter(valid_580267, JBool, required = false,
                                 default = newJBool(true))
  if valid_580267 != nil:
    section.add "prettyPrint", valid_580267
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

proc call*(call_580269: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_580252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Annotation store within the parent dataset.
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_580252;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; annotationStoreId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresCreate
  ## Creates a new Annotation store within the parent dataset.
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
  ##         : The name of the dataset this Annotation store belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   annotationStoreId: string
  ##                    : The ID of the Annotation store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  var body_580273 = newJObject()
  add(query_580272, "upload_protocol", newJString(uploadProtocol))
  add(query_580272, "fields", newJString(fields))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(query_580272, "alt", newJString(alt))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(query_580272, "callback", newJString(callback))
  add(query_580272, "access_token", newJString(accessToken))
  add(query_580272, "uploadType", newJString(uploadType))
  add(path_580271, "parent", newJString(parent))
  add(query_580272, "key", newJString(key))
  add(query_580272, "$.xgafv", newJString(Xgafv))
  add(query_580272, "annotationStoreId", newJString(annotationStoreId))
  if body != nil:
    body_580273 = body
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  result = call_580270.call(path_580271, query_580272, nil, nil, body_580273)

var healthcareProjectsLocationsDatasetsAnnotationStoresCreate* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_580252(
    name: "healthcareProjectsLocationsDatasetsAnnotationStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/annotationStores", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_580253,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresCreate_580254,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresList_580230 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresList_580232(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/annotationStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresList_580231(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the Annotation stores in the given dataset for a source store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the dataset.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580233 = path.getOrDefault("parent")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "parent", valid_580233
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##           : Limit on the number of Annotation stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
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
  var valid_580236 = query.getOrDefault("pageToken")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "pageToken", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("oauth_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "oauth_token", valid_580239
  var valid_580240 = query.getOrDefault("callback")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "callback", valid_580240
  var valid_580241 = query.getOrDefault("access_token")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "access_token", valid_580241
  var valid_580242 = query.getOrDefault("uploadType")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "uploadType", valid_580242
  var valid_580243 = query.getOrDefault("key")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "key", valid_580243
  var valid_580244 = query.getOrDefault("$.xgafv")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("1"))
  if valid_580244 != nil:
    section.add "$.xgafv", valid_580244
  var valid_580245 = query.getOrDefault("pageSize")
  valid_580245 = validateParameter(valid_580245, JInt, required = false, default = nil)
  if valid_580245 != nil:
    section.add "pageSize", valid_580245
  var valid_580246 = query.getOrDefault("prettyPrint")
  valid_580246 = validateParameter(valid_580246, JBool, required = false,
                                 default = newJBool(true))
  if valid_580246 != nil:
    section.add "prettyPrint", valid_580246
  var valid_580247 = query.getOrDefault("filter")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "filter", valid_580247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580248: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresList_580230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Annotation stores in the given dataset for a source store.
  ## 
  let valid = call_580248.validator(path, query, header, formData, body)
  let scheme = call_580248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580248.url(scheme.get, call_580248.host, call_580248.base,
                         call_580248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580248, url, valid)

proc call*(call_580249: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresList_580230;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresList
  ## Lists the Annotation stores in the given dataset for a source store.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##         : Name of the dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of Annotation stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  var path_580250 = newJObject()
  var query_580251 = newJObject()
  add(query_580251, "upload_protocol", newJString(uploadProtocol))
  add(query_580251, "fields", newJString(fields))
  add(query_580251, "pageToken", newJString(pageToken))
  add(query_580251, "quotaUser", newJString(quotaUser))
  add(query_580251, "alt", newJString(alt))
  add(query_580251, "oauth_token", newJString(oauthToken))
  add(query_580251, "callback", newJString(callback))
  add(query_580251, "access_token", newJString(accessToken))
  add(query_580251, "uploadType", newJString(uploadType))
  add(path_580250, "parent", newJString(parent))
  add(query_580251, "key", newJString(key))
  add(query_580251, "$.xgafv", newJString(Xgafv))
  add(query_580251, "pageSize", newJInt(pageSize))
  add(query_580251, "prettyPrint", newJBool(prettyPrint))
  add(query_580251, "filter", newJString(filter))
  result = call_580249.call(path_580250, query_580251, nil, nil, nil)

var healthcareProjectsLocationsDatasetsAnnotationStoresList* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresList_580230(
    name: "healthcareProjectsLocationsDatasetsAnnotationStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/annotationStores", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresList_580231,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresList_580232,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_580296 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_580298(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/annotations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_580297(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new Annotation record. It is
  ## valid to create Annotation objects for the same source more than once since
  ## a unique ID is assigned to each record by this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the Annotation store this annotation belongs to. For example,
  ## 
  ## `projects/my-project/locations/us-central1/datasets/mydataset/annotationStores/myannotationstore`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580299 = path.getOrDefault("parent")
  valid_580299 = validateParameter(valid_580299, JString, required = true,
                                 default = nil)
  if valid_580299 != nil:
    section.add "parent", valid_580299
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
  var valid_580300 = query.getOrDefault("upload_protocol")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "upload_protocol", valid_580300
  var valid_580301 = query.getOrDefault("fields")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "fields", valid_580301
  var valid_580302 = query.getOrDefault("quotaUser")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "quotaUser", valid_580302
  var valid_580303 = query.getOrDefault("alt")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = newJString("json"))
  if valid_580303 != nil:
    section.add "alt", valid_580303
  var valid_580304 = query.getOrDefault("oauth_token")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "oauth_token", valid_580304
  var valid_580305 = query.getOrDefault("callback")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "callback", valid_580305
  var valid_580306 = query.getOrDefault("access_token")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "access_token", valid_580306
  var valid_580307 = query.getOrDefault("uploadType")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "uploadType", valid_580307
  var valid_580308 = query.getOrDefault("key")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "key", valid_580308
  var valid_580309 = query.getOrDefault("$.xgafv")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = newJString("1"))
  if valid_580309 != nil:
    section.add "$.xgafv", valid_580309
  var valid_580310 = query.getOrDefault("prettyPrint")
  valid_580310 = validateParameter(valid_580310, JBool, required = false,
                                 default = newJBool(true))
  if valid_580310 != nil:
    section.add "prettyPrint", valid_580310
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

proc call*(call_580312: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_580296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Annotation record. It is
  ## valid to create Annotation objects for the same source more than once since
  ## a unique ID is assigned to each record by this service.
  ## 
  let valid = call_580312.validator(path, query, header, formData, body)
  let scheme = call_580312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580312.url(scheme.get, call_580312.host, call_580312.base,
                         call_580312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580312, url, valid)

proc call*(call_580313: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_580296;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate
  ## Creates a new Annotation record. It is
  ## valid to create Annotation objects for the same source more than once since
  ## a unique ID is assigned to each record by this service.
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
  ##         : The name of the Annotation store this annotation belongs to. For example,
  ## 
  ## `projects/my-project/locations/us-central1/datasets/mydataset/annotationStores/myannotationstore`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580314 = newJObject()
  var query_580315 = newJObject()
  var body_580316 = newJObject()
  add(query_580315, "upload_protocol", newJString(uploadProtocol))
  add(query_580315, "fields", newJString(fields))
  add(query_580315, "quotaUser", newJString(quotaUser))
  add(query_580315, "alt", newJString(alt))
  add(query_580315, "oauth_token", newJString(oauthToken))
  add(query_580315, "callback", newJString(callback))
  add(query_580315, "access_token", newJString(accessToken))
  add(query_580315, "uploadType", newJString(uploadType))
  add(path_580314, "parent", newJString(parent))
  add(query_580315, "key", newJString(key))
  add(query_580315, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580316 = body
  add(query_580315, "prettyPrint", newJBool(prettyPrint))
  result = call_580313.call(path_580314, query_580315, nil, nil, body_580316)

var healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_580296(name: "healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/annotations", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_580297,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsCreate_580298,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_580274 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_580276(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/annotations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_580275(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the Annotations in the given
  ## Annotation store for a source
  ## resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the Annotation store to retrieve Annotations from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580277 = path.getOrDefault("parent")
  valid_580277 = validateParameter(valid_580277, JString, required = true,
                                 default = nil)
  if valid_580277 != nil:
    section.add "parent", valid_580277
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##           : Limit on the number of Annotations to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Restricts Annotations returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Fields/functions available for filtering are:
  ## - source_version
  section = newJObject()
  var valid_580278 = query.getOrDefault("upload_protocol")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "upload_protocol", valid_580278
  var valid_580279 = query.getOrDefault("fields")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "fields", valid_580279
  var valid_580280 = query.getOrDefault("pageToken")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "pageToken", valid_580280
  var valid_580281 = query.getOrDefault("quotaUser")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "quotaUser", valid_580281
  var valid_580282 = query.getOrDefault("alt")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("json"))
  if valid_580282 != nil:
    section.add "alt", valid_580282
  var valid_580283 = query.getOrDefault("oauth_token")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "oauth_token", valid_580283
  var valid_580284 = query.getOrDefault("callback")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "callback", valid_580284
  var valid_580285 = query.getOrDefault("access_token")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "access_token", valid_580285
  var valid_580286 = query.getOrDefault("uploadType")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "uploadType", valid_580286
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("$.xgafv")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("1"))
  if valid_580288 != nil:
    section.add "$.xgafv", valid_580288
  var valid_580289 = query.getOrDefault("pageSize")
  valid_580289 = validateParameter(valid_580289, JInt, required = false, default = nil)
  if valid_580289 != nil:
    section.add "pageSize", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
  var valid_580291 = query.getOrDefault("filter")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "filter", valid_580291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580292: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_580274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Annotations in the given
  ## Annotation store for a source
  ## resource.
  ## 
  let valid = call_580292.validator(path, query, header, formData, body)
  let scheme = call_580292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580292.url(scheme.get, call_580292.host, call_580292.base,
                         call_580292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580292, url, valid)

proc call*(call_580293: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_580274;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList
  ## Lists the Annotations in the given
  ## Annotation store for a source
  ## resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##         : Name of the Annotation store to retrieve Annotations from.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of Annotations to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Restricts Annotations returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Fields/functions available for filtering are:
  ## - source_version
  var path_580294 = newJObject()
  var query_580295 = newJObject()
  add(query_580295, "upload_protocol", newJString(uploadProtocol))
  add(query_580295, "fields", newJString(fields))
  add(query_580295, "pageToken", newJString(pageToken))
  add(query_580295, "quotaUser", newJString(quotaUser))
  add(query_580295, "alt", newJString(alt))
  add(query_580295, "oauth_token", newJString(oauthToken))
  add(query_580295, "callback", newJString(callback))
  add(query_580295, "access_token", newJString(accessToken))
  add(query_580295, "uploadType", newJString(uploadType))
  add(path_580294, "parent", newJString(parent))
  add(query_580295, "key", newJString(key))
  add(query_580295, "$.xgafv", newJString(Xgafv))
  add(query_580295, "pageSize", newJInt(pageSize))
  add(query_580295, "prettyPrint", newJBool(prettyPrint))
  add(query_580295, "filter", newJString(filter))
  result = call_580293.call(path_580294, query_580295, nil, nil, nil)

var healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_580274(
    name: "healthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/annotations", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_580275,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresAnnotationsList_580276,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsCreate_580338 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsCreate_580340(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsCreate_580339(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new health dataset. Results are returned through the
  ## Operation interface which returns either an
  ## `Operation.response` which contains a Dataset or
  ## `Operation.error`. The metadata
  ## field type is OperationMetadata.
  ## A Google Cloud Platform project can contain up to 500 datasets across all
  ## regions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in which the dataset should be created (e.g.,
  ## `projects/{project_id}/locations/{location_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580341 = path.getOrDefault("parent")
  valid_580341 = validateParameter(valid_580341, JString, required = true,
                                 default = nil)
  if valid_580341 != nil:
    section.add "parent", valid_580341
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
  ##   datasetId: JString
  ##            : The ID of the dataset that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580342 = query.getOrDefault("upload_protocol")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "upload_protocol", valid_580342
  var valid_580343 = query.getOrDefault("fields")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "fields", valid_580343
  var valid_580344 = query.getOrDefault("quotaUser")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "quotaUser", valid_580344
  var valid_580345 = query.getOrDefault("alt")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = newJString("json"))
  if valid_580345 != nil:
    section.add "alt", valid_580345
  var valid_580346 = query.getOrDefault("oauth_token")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "oauth_token", valid_580346
  var valid_580347 = query.getOrDefault("callback")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "callback", valid_580347
  var valid_580348 = query.getOrDefault("access_token")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "access_token", valid_580348
  var valid_580349 = query.getOrDefault("uploadType")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "uploadType", valid_580349
  var valid_580350 = query.getOrDefault("datasetId")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "datasetId", valid_580350
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("$.xgafv")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = newJString("1"))
  if valid_580352 != nil:
    section.add "$.xgafv", valid_580352
  var valid_580353 = query.getOrDefault("prettyPrint")
  valid_580353 = validateParameter(valid_580353, JBool, required = false,
                                 default = newJBool(true))
  if valid_580353 != nil:
    section.add "prettyPrint", valid_580353
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

proc call*(call_580355: Call_HealthcareProjectsLocationsDatasetsCreate_580338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new health dataset. Results are returned through the
  ## Operation interface which returns either an
  ## `Operation.response` which contains a Dataset or
  ## `Operation.error`. The metadata
  ## field type is OperationMetadata.
  ## A Google Cloud Platform project can contain up to 500 datasets across all
  ## regions.
  ## 
  let valid = call_580355.validator(path, query, header, formData, body)
  let scheme = call_580355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580355.url(scheme.get, call_580355.host, call_580355.base,
                         call_580355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580355, url, valid)

proc call*(call_580356: Call_HealthcareProjectsLocationsDatasetsCreate_580338;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          datasetId: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsCreate
  ## Creates a new health dataset. Results are returned through the
  ## Operation interface which returns either an
  ## `Operation.response` which contains a Dataset or
  ## `Operation.error`. The metadata
  ## field type is OperationMetadata.
  ## A Google Cloud Platform project can contain up to 500 datasets across all
  ## regions.
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
  ##         : The name of the project in which the dataset should be created (e.g.,
  ## `projects/{project_id}/locations/{location_id}`).
  ##   datasetId: string
  ##            : The ID of the dataset that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580357 = newJObject()
  var query_580358 = newJObject()
  var body_580359 = newJObject()
  add(query_580358, "upload_protocol", newJString(uploadProtocol))
  add(query_580358, "fields", newJString(fields))
  add(query_580358, "quotaUser", newJString(quotaUser))
  add(query_580358, "alt", newJString(alt))
  add(query_580358, "oauth_token", newJString(oauthToken))
  add(query_580358, "callback", newJString(callback))
  add(query_580358, "access_token", newJString(accessToken))
  add(query_580358, "uploadType", newJString(uploadType))
  add(path_580357, "parent", newJString(parent))
  add(query_580358, "datasetId", newJString(datasetId))
  add(query_580358, "key", newJString(key))
  add(query_580358, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580359 = body
  add(query_580358, "prettyPrint", newJBool(prettyPrint))
  result = call_580356.call(path_580357, query_580358, nil, nil, body_580359)

var healthcareProjectsLocationsDatasetsCreate* = Call_HealthcareProjectsLocationsDatasetsCreate_580338(
    name: "healthcareProjectsLocationsDatasetsCreate", meth: HttpMethod.HttpPost,
    host: "healthcare.googleapis.com", route: "/v1alpha2/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsCreate_580339,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsCreate_580340,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsList_580317 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsList_580319(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsList_580318(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the health datasets in the current project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project whose datasets should be listed (e.g.,
  ## `projects/{project_id}/locations/{location_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580320 = path.getOrDefault("parent")
  valid_580320 = validateParameter(valid_580320, JString, required = true,
                                 default = nil)
  if valid_580320 != nil:
    section.add "parent", valid_580320
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
  ##           : The maximum number of items to return. Capped to 100 if not specified.
  ## May not be larger than 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580321 = query.getOrDefault("upload_protocol")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "upload_protocol", valid_580321
  var valid_580322 = query.getOrDefault("fields")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "fields", valid_580322
  var valid_580323 = query.getOrDefault("pageToken")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "pageToken", valid_580323
  var valid_580324 = query.getOrDefault("quotaUser")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "quotaUser", valid_580324
  var valid_580325 = query.getOrDefault("alt")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("json"))
  if valid_580325 != nil:
    section.add "alt", valid_580325
  var valid_580326 = query.getOrDefault("oauth_token")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "oauth_token", valid_580326
  var valid_580327 = query.getOrDefault("callback")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "callback", valid_580327
  var valid_580328 = query.getOrDefault("access_token")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "access_token", valid_580328
  var valid_580329 = query.getOrDefault("uploadType")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "uploadType", valid_580329
  var valid_580330 = query.getOrDefault("key")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "key", valid_580330
  var valid_580331 = query.getOrDefault("$.xgafv")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = newJString("1"))
  if valid_580331 != nil:
    section.add "$.xgafv", valid_580331
  var valid_580332 = query.getOrDefault("pageSize")
  valid_580332 = validateParameter(valid_580332, JInt, required = false, default = nil)
  if valid_580332 != nil:
    section.add "pageSize", valid_580332
  var valid_580333 = query.getOrDefault("prettyPrint")
  valid_580333 = validateParameter(valid_580333, JBool, required = false,
                                 default = newJBool(true))
  if valid_580333 != nil:
    section.add "prettyPrint", valid_580333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580334: Call_HealthcareProjectsLocationsDatasetsList_580317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the health datasets in the current project.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_HealthcareProjectsLocationsDatasetsList_580317;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsList
  ## Lists the health datasets in the current project.
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
  ##         : The name of the project whose datasets should be listed (e.g.,
  ## `projects/{project_id}/locations/{location_id}`).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Capped to 100 if not specified.
  ## May not be larger than 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580336 = newJObject()
  var query_580337 = newJObject()
  add(query_580337, "upload_protocol", newJString(uploadProtocol))
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "pageToken", newJString(pageToken))
  add(query_580337, "quotaUser", newJString(quotaUser))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(query_580337, "callback", newJString(callback))
  add(query_580337, "access_token", newJString(accessToken))
  add(query_580337, "uploadType", newJString(uploadType))
  add(path_580336, "parent", newJString(parent))
  add(query_580337, "key", newJString(key))
  add(query_580337, "$.xgafv", newJString(Xgafv))
  add(query_580337, "pageSize", newJInt(pageSize))
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  result = call_580335.call(path_580336, query_580337, nil, nil, nil)

var healthcareProjectsLocationsDatasetsList* = Call_HealthcareProjectsLocationsDatasetsList_580317(
    name: "healthcareProjectsLocationsDatasetsList", meth: HttpMethod.HttpGet,
    host: "healthcare.googleapis.com", route: "/v1alpha2/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsList_580318, base: "/",
    url: url_HealthcareProjectsLocationsDatasetsList_580319,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580382 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580384(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580383(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new DICOM store within the parent dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this DICOM store belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580385 = path.getOrDefault("parent")
  valid_580385 = validateParameter(valid_580385, JString, required = true,
                                 default = nil)
  if valid_580385 != nil:
    section.add "parent", valid_580385
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
  ##   dicomStoreId: JString
  ##               : The ID of the DICOM store that is being created.
  ## Any string value up to 256 characters in length.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580386 = query.getOrDefault("upload_protocol")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "upload_protocol", valid_580386
  var valid_580387 = query.getOrDefault("fields")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "fields", valid_580387
  var valid_580388 = query.getOrDefault("quotaUser")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "quotaUser", valid_580388
  var valid_580389 = query.getOrDefault("alt")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = newJString("json"))
  if valid_580389 != nil:
    section.add "alt", valid_580389
  var valid_580390 = query.getOrDefault("oauth_token")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "oauth_token", valid_580390
  var valid_580391 = query.getOrDefault("callback")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "callback", valid_580391
  var valid_580392 = query.getOrDefault("access_token")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "access_token", valid_580392
  var valid_580393 = query.getOrDefault("uploadType")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "uploadType", valid_580393
  var valid_580394 = query.getOrDefault("key")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "key", valid_580394
  var valid_580395 = query.getOrDefault("$.xgafv")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = newJString("1"))
  if valid_580395 != nil:
    section.add "$.xgafv", valid_580395
  var valid_580396 = query.getOrDefault("dicomStoreId")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "dicomStoreId", valid_580396
  var valid_580397 = query.getOrDefault("prettyPrint")
  valid_580397 = validateParameter(valid_580397, JBool, required = false,
                                 default = newJBool(true))
  if valid_580397 != nil:
    section.add "prettyPrint", valid_580397
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

proc call*(call_580399: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new DICOM store within the parent dataset.
  ## 
  let valid = call_580399.validator(path, query, header, formData, body)
  let scheme = call_580399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580399.url(scheme.get, call_580399.host, call_580399.base,
                         call_580399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580399, url, valid)

proc call*(call_580400: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580382;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; dicomStoreId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresCreate
  ## Creates a new DICOM store within the parent dataset.
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
  ##         : The name of the dataset this DICOM store belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   dicomStoreId: string
  ##               : The ID of the DICOM store that is being created.
  ## Any string value up to 256 characters in length.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580401 = newJObject()
  var query_580402 = newJObject()
  var body_580403 = newJObject()
  add(query_580402, "upload_protocol", newJString(uploadProtocol))
  add(query_580402, "fields", newJString(fields))
  add(query_580402, "quotaUser", newJString(quotaUser))
  add(query_580402, "alt", newJString(alt))
  add(query_580402, "oauth_token", newJString(oauthToken))
  add(query_580402, "callback", newJString(callback))
  add(query_580402, "access_token", newJString(accessToken))
  add(query_580402, "uploadType", newJString(uploadType))
  add(path_580401, "parent", newJString(parent))
  add(query_580402, "key", newJString(key))
  add(query_580402, "$.xgafv", newJString(Xgafv))
  add(query_580402, "dicomStoreId", newJString(dicomStoreId))
  if body != nil:
    body_580403 = body
  add(query_580402, "prettyPrint", newJBool(prettyPrint))
  result = call_580400.call(path_580401, query_580402, nil, nil, body_580403)

var healthcareProjectsLocationsDatasetsDicomStoresCreate* = Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580382(
    name: "healthcareProjectsLocationsDatasetsDicomStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580383,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580384,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresList_580360 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresList_580362(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresList_580361(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the DICOM stores in the given dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the dataset.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580363 = path.getOrDefault("parent")
  valid_580363 = validateParameter(valid_580363, JString, required = true,
                                 default = nil)
  if valid_580363 != nil:
    section.add "parent", valid_580363
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##           : Limit on the number of DICOM stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  section = newJObject()
  var valid_580364 = query.getOrDefault("upload_protocol")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "upload_protocol", valid_580364
  var valid_580365 = query.getOrDefault("fields")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "fields", valid_580365
  var valid_580366 = query.getOrDefault("pageToken")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "pageToken", valid_580366
  var valid_580367 = query.getOrDefault("quotaUser")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "quotaUser", valid_580367
  var valid_580368 = query.getOrDefault("alt")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = newJString("json"))
  if valid_580368 != nil:
    section.add "alt", valid_580368
  var valid_580369 = query.getOrDefault("oauth_token")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "oauth_token", valid_580369
  var valid_580370 = query.getOrDefault("callback")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "callback", valid_580370
  var valid_580371 = query.getOrDefault("access_token")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "access_token", valid_580371
  var valid_580372 = query.getOrDefault("uploadType")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "uploadType", valid_580372
  var valid_580373 = query.getOrDefault("key")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "key", valid_580373
  var valid_580374 = query.getOrDefault("$.xgafv")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = newJString("1"))
  if valid_580374 != nil:
    section.add "$.xgafv", valid_580374
  var valid_580375 = query.getOrDefault("pageSize")
  valid_580375 = validateParameter(valid_580375, JInt, required = false, default = nil)
  if valid_580375 != nil:
    section.add "pageSize", valid_580375
  var valid_580376 = query.getOrDefault("prettyPrint")
  valid_580376 = validateParameter(valid_580376, JBool, required = false,
                                 default = newJBool(true))
  if valid_580376 != nil:
    section.add "prettyPrint", valid_580376
  var valid_580377 = query.getOrDefault("filter")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "filter", valid_580377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580378: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_580360;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the DICOM stores in the given dataset.
  ## 
  let valid = call_580378.validator(path, query, header, formData, body)
  let scheme = call_580378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580378.url(scheme.get, call_580378.host, call_580378.base,
                         call_580378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580378, url, valid)

proc call*(call_580379: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_580360;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresList
  ## Lists the DICOM stores in the given dataset.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##         : Name of the dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of DICOM stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  var path_580380 = newJObject()
  var query_580381 = newJObject()
  add(query_580381, "upload_protocol", newJString(uploadProtocol))
  add(query_580381, "fields", newJString(fields))
  add(query_580381, "pageToken", newJString(pageToken))
  add(query_580381, "quotaUser", newJString(quotaUser))
  add(query_580381, "alt", newJString(alt))
  add(query_580381, "oauth_token", newJString(oauthToken))
  add(query_580381, "callback", newJString(callback))
  add(query_580381, "access_token", newJString(accessToken))
  add(query_580381, "uploadType", newJString(uploadType))
  add(path_580380, "parent", newJString(parent))
  add(query_580381, "key", newJString(key))
  add(query_580381, "$.xgafv", newJString(Xgafv))
  add(query_580381, "pageSize", newJInt(pageSize))
  add(query_580381, "prettyPrint", newJBool(prettyPrint))
  add(query_580381, "filter", newJString(filter))
  result = call_580379.call(path_580380, query_580381, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresList* = Call_HealthcareProjectsLocationsDatasetsDicomStoresList_580360(
    name: "healthcareProjectsLocationsDatasetsDicomStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresList_580361,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresList_580362,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_580424 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_580426(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_580425(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## StoreInstances stores DICOM instances associated with study instance unique
  ## identifiers (SUID). See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.5.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the StoreInstances DICOMweb request (e.g.,
  ## `studies/[{study_id}]`). Note that the `study_uid` is optional.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580427 = path.getOrDefault("parent")
  valid_580427 = validateParameter(valid_580427, JString, required = true,
                                 default = nil)
  if valid_580427 != nil:
    section.add "parent", valid_580427
  var valid_580428 = path.getOrDefault("dicomWebPath")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "dicomWebPath", valid_580428
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
  var valid_580429 = query.getOrDefault("upload_protocol")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "upload_protocol", valid_580429
  var valid_580430 = query.getOrDefault("fields")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "fields", valid_580430
  var valid_580431 = query.getOrDefault("quotaUser")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "quotaUser", valid_580431
  var valid_580432 = query.getOrDefault("alt")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = newJString("json"))
  if valid_580432 != nil:
    section.add "alt", valid_580432
  var valid_580433 = query.getOrDefault("oauth_token")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "oauth_token", valid_580433
  var valid_580434 = query.getOrDefault("callback")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "callback", valid_580434
  var valid_580435 = query.getOrDefault("access_token")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "access_token", valid_580435
  var valid_580436 = query.getOrDefault("uploadType")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "uploadType", valid_580436
  var valid_580437 = query.getOrDefault("key")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "key", valid_580437
  var valid_580438 = query.getOrDefault("$.xgafv")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = newJString("1"))
  if valid_580438 != nil:
    section.add "$.xgafv", valid_580438
  var valid_580439 = query.getOrDefault("prettyPrint")
  valid_580439 = validateParameter(valid_580439, JBool, required = false,
                                 default = newJBool(true))
  if valid_580439 != nil:
    section.add "prettyPrint", valid_580439
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

proc call*(call_580441: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_580424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## StoreInstances stores DICOM instances associated with study instance unique
  ## identifiers (SUID). See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.5.
  ## 
  let valid = call_580441.validator(path, query, header, formData, body)
  let scheme = call_580441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580441.url(scheme.get, call_580441.host, call_580441.base,
                         call_580441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580441, url, valid)

proc call*(call_580442: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_580424;
          parent: string; dicomWebPath: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances
  ## StoreInstances stores DICOM instances associated with study instance unique
  ## identifiers (SUID). See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.5.
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
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dicomWebPath: string (required)
  ##               : The path of the StoreInstances DICOMweb request (e.g.,
  ## `studies/[{study_id}]`). Note that the `study_uid` is optional.
  var path_580443 = newJObject()
  var query_580444 = newJObject()
  var body_580445 = newJObject()
  add(query_580444, "upload_protocol", newJString(uploadProtocol))
  add(query_580444, "fields", newJString(fields))
  add(query_580444, "quotaUser", newJString(quotaUser))
  add(query_580444, "alt", newJString(alt))
  add(query_580444, "oauth_token", newJString(oauthToken))
  add(query_580444, "callback", newJString(callback))
  add(query_580444, "access_token", newJString(accessToken))
  add(query_580444, "uploadType", newJString(uploadType))
  add(path_580443, "parent", newJString(parent))
  add(query_580444, "key", newJString(key))
  add(query_580444, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580445 = body
  add(query_580444, "prettyPrint", newJBool(prettyPrint))
  add(path_580443, "dicomWebPath", newJString(dicomWebPath))
  result = call_580442.call(path_580443, query_580444, nil, nil, body_580445)

var healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances* = Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_580424(name: "healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_580425,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesStoreInstances_580426,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_580404 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_580406(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_580405(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## RetrieveRenderedFrames returns instances associated with the given study,
  ## series, SOP Instance UID and frame numbers in an acceptable Rendered Media
  ## Type. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the RetrieveRenderedFrames DICOMweb request (e.g.,
  ## 
  ## `studies/{study_id}/series/{series_id}/instances/{instance_id}/frames/{frame_list}/rendered`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580407 = path.getOrDefault("parent")
  valid_580407 = validateParameter(valid_580407, JString, required = true,
                                 default = nil)
  if valid_580407 != nil:
    section.add "parent", valid_580407
  var valid_580408 = path.getOrDefault("dicomWebPath")
  valid_580408 = validateParameter(valid_580408, JString, required = true,
                                 default = nil)
  if valid_580408 != nil:
    section.add "dicomWebPath", valid_580408
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
  var valid_580409 = query.getOrDefault("upload_protocol")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "upload_protocol", valid_580409
  var valid_580410 = query.getOrDefault("fields")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "fields", valid_580410
  var valid_580411 = query.getOrDefault("quotaUser")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "quotaUser", valid_580411
  var valid_580412 = query.getOrDefault("alt")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = newJString("json"))
  if valid_580412 != nil:
    section.add "alt", valid_580412
  var valid_580413 = query.getOrDefault("oauth_token")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "oauth_token", valid_580413
  var valid_580414 = query.getOrDefault("callback")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "callback", valid_580414
  var valid_580415 = query.getOrDefault("access_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "access_token", valid_580415
  var valid_580416 = query.getOrDefault("uploadType")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "uploadType", valid_580416
  var valid_580417 = query.getOrDefault("key")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "key", valid_580417
  var valid_580418 = query.getOrDefault("$.xgafv")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("1"))
  if valid_580418 != nil:
    section.add "$.xgafv", valid_580418
  var valid_580419 = query.getOrDefault("prettyPrint")
  valid_580419 = validateParameter(valid_580419, JBool, required = false,
                                 default = newJBool(true))
  if valid_580419 != nil:
    section.add "prettyPrint", valid_580419
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580420: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_580404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RetrieveRenderedFrames returns instances associated with the given study,
  ## series, SOP Instance UID and frame numbers in an acceptable Rendered Media
  ## Type. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_580404;
          parent: string; dicomWebPath: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered
  ## RetrieveRenderedFrames returns instances associated with the given study,
  ## series, SOP Instance UID and frame numbers in an acceptable Rendered Media
  ## Type. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
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
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dicomWebPath: string (required)
  ##               : The path of the RetrieveRenderedFrames DICOMweb request (e.g.,
  ## 
  ## `studies/{study_id}/series/{series_id}/instances/{instance_id}/frames/{frame_list}/rendered`).
  var path_580422 = newJObject()
  var query_580423 = newJObject()
  add(query_580423, "upload_protocol", newJString(uploadProtocol))
  add(query_580423, "fields", newJString(fields))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(query_580423, "alt", newJString(alt))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(query_580423, "callback", newJString(callback))
  add(query_580423, "access_token", newJString(accessToken))
  add(query_580423, "uploadType", newJString(uploadType))
  add(path_580422, "parent", newJString(parent))
  add(query_580423, "key", newJString(key))
  add(query_580423, "$.xgafv", newJString(Xgafv))
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  add(path_580422, "dicomWebPath", newJString(dicomWebPath))
  result = call_580421.call(path_580422, query_580423, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered* = Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_580404(name: "healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_580405,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesFramesRendered_580406,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_580446 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_580448(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_580447(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## DeleteInstance deletes an instance associated with the given study, series,
  ## and SOP Instance UID. Delete requests are equivalent to the GET requests
  ## specified in the WADO-RS standard.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the DeleteInstance request (e.g.,
  ## `studies/{study_id}/series/{series_id}/instances/{instance_id}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580449 = path.getOrDefault("parent")
  valid_580449 = validateParameter(valid_580449, JString, required = true,
                                 default = nil)
  if valid_580449 != nil:
    section.add "parent", valid_580449
  var valid_580450 = path.getOrDefault("dicomWebPath")
  valid_580450 = validateParameter(valid_580450, JString, required = true,
                                 default = nil)
  if valid_580450 != nil:
    section.add "dicomWebPath", valid_580450
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
  var valid_580451 = query.getOrDefault("upload_protocol")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "upload_protocol", valid_580451
  var valid_580452 = query.getOrDefault("fields")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "fields", valid_580452
  var valid_580453 = query.getOrDefault("quotaUser")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "quotaUser", valid_580453
  var valid_580454 = query.getOrDefault("alt")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = newJString("json"))
  if valid_580454 != nil:
    section.add "alt", valid_580454
  var valid_580455 = query.getOrDefault("oauth_token")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "oauth_token", valid_580455
  var valid_580456 = query.getOrDefault("callback")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "callback", valid_580456
  var valid_580457 = query.getOrDefault("access_token")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "access_token", valid_580457
  var valid_580458 = query.getOrDefault("uploadType")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "uploadType", valid_580458
  var valid_580459 = query.getOrDefault("key")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "key", valid_580459
  var valid_580460 = query.getOrDefault("$.xgafv")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = newJString("1"))
  if valid_580460 != nil:
    section.add "$.xgafv", valid_580460
  var valid_580461 = query.getOrDefault("prettyPrint")
  valid_580461 = validateParameter(valid_580461, JBool, required = false,
                                 default = newJBool(true))
  if valid_580461 != nil:
    section.add "prettyPrint", valid_580461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580462: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_580446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## DeleteInstance deletes an instance associated with the given study, series,
  ## and SOP Instance UID. Delete requests are equivalent to the GET requests
  ## specified in the WADO-RS standard.
  ## 
  let valid = call_580462.validator(path, query, header, formData, body)
  let scheme = call_580462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580462.url(scheme.get, call_580462.host, call_580462.base,
                         call_580462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580462, url, valid)

proc call*(call_580463: Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_580446;
          parent: string; dicomWebPath: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete
  ## DeleteInstance deletes an instance associated with the given study, series,
  ## and SOP Instance UID. Delete requests are equivalent to the GET requests
  ## specified in the WADO-RS standard.
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
  ##         : The name of the DICOM store that is being accessed (e.g.,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dicomWebPath: string (required)
  ##               : The path of the DeleteInstance request (e.g.,
  ## `studies/{study_id}/series/{series_id}/instances/{instance_id}`).
  var path_580464 = newJObject()
  var query_580465 = newJObject()
  add(query_580465, "upload_protocol", newJString(uploadProtocol))
  add(query_580465, "fields", newJString(fields))
  add(query_580465, "quotaUser", newJString(quotaUser))
  add(query_580465, "alt", newJString(alt))
  add(query_580465, "oauth_token", newJString(oauthToken))
  add(query_580465, "callback", newJString(callback))
  add(query_580465, "access_token", newJString(accessToken))
  add(query_580465, "uploadType", newJString(uploadType))
  add(path_580464, "parent", newJString(parent))
  add(query_580465, "key", newJString(key))
  add(query_580465, "$.xgafv", newJString(Xgafv))
  add(query_580465, "prettyPrint", newJBool(prettyPrint))
  add(path_580464, "dicomWebPath", newJString(dicomWebPath))
  result = call_580463.call(path_580464, query_580465, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete* = Call_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_580446(name: "healthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_580447,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresDicomWebStudiesSeriesInstancesDelete_580448,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580466 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580468(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580467(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Executes all the requests in the given Bundle.
  ## 
  ## Implements the FHIR standard [batch/transaction
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#transaction).
  ## 
  ## Supports all interactions within a bundle, except search. This method
  ## accepts Bundles of type `batch` and `transaction`, processing them
  ## according to the [batch processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.1)
  ## and [transaction processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.2).
  ## 
  ## The request body must contain a JSON-encoded FHIR `Bundle` resource, and
  ## the request headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## For a batch bundle or a successful transaction the response body will
  ## contain a JSON-encoded representation of a `Bundle` resource of type
  ## `batch-response` or `transaction-response` containing one entry for each
  ## entry in the request, with the outcome of processing the entry. In the
  ## case of an error for a transaction bundle, the response body will contain
  ## a JSON-encoded `OperationOutcome` resource describing the reason for the
  ## error. If the request cannot be mapped to a valid API method on a FHIR
  ## store, a generic GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the FHIR store in which this bundle will be executed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580469 = path.getOrDefault("parent")
  valid_580469 = validateParameter(valid_580469, JString, required = true,
                                 default = nil)
  if valid_580469 != nil:
    section.add "parent", valid_580469
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
  var valid_580470 = query.getOrDefault("upload_protocol")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "upload_protocol", valid_580470
  var valid_580471 = query.getOrDefault("fields")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "fields", valid_580471
  var valid_580472 = query.getOrDefault("quotaUser")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "quotaUser", valid_580472
  var valid_580473 = query.getOrDefault("alt")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = newJString("json"))
  if valid_580473 != nil:
    section.add "alt", valid_580473
  var valid_580474 = query.getOrDefault("oauth_token")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "oauth_token", valid_580474
  var valid_580475 = query.getOrDefault("callback")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "callback", valid_580475
  var valid_580476 = query.getOrDefault("access_token")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "access_token", valid_580476
  var valid_580477 = query.getOrDefault("uploadType")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "uploadType", valid_580477
  var valid_580478 = query.getOrDefault("key")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "key", valid_580478
  var valid_580479 = query.getOrDefault("$.xgafv")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = newJString("1"))
  if valid_580479 != nil:
    section.add "$.xgafv", valid_580479
  var valid_580480 = query.getOrDefault("prettyPrint")
  valid_580480 = validateParameter(valid_580480, JBool, required = false,
                                 default = newJBool(true))
  if valid_580480 != nil:
    section.add "prettyPrint", valid_580480
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

proc call*(call_580482: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580466;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes all the requests in the given Bundle.
  ## 
  ## Implements the FHIR standard [batch/transaction
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#transaction).
  ## 
  ## Supports all interactions within a bundle, except search. This method
  ## accepts Bundles of type `batch` and `transaction`, processing them
  ## according to the [batch processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.1)
  ## and [transaction processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.2).
  ## 
  ## The request body must contain a JSON-encoded FHIR `Bundle` resource, and
  ## the request headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## For a batch bundle or a successful transaction the response body will
  ## contain a JSON-encoded representation of a `Bundle` resource of type
  ## `batch-response` or `transaction-response` containing one entry for each
  ## entry in the request, with the outcome of processing the entry. In the
  ## case of an error for a transaction bundle, the response body will contain
  ## a JSON-encoded `OperationOutcome` resource describing the reason for the
  ## error. If the request cannot be mapped to a valid API method on a FHIR
  ## store, a generic GCP error might be returned instead.
  ## 
  let valid = call_580482.validator(path, query, header, formData, body)
  let scheme = call_580482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580482.url(scheme.get, call_580482.host, call_580482.base,
                         call_580482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580482, url, valid)

proc call*(call_580483: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580466;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle
  ## Executes all the requests in the given Bundle.
  ## 
  ## Implements the FHIR standard [batch/transaction
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#transaction).
  ## 
  ## Supports all interactions within a bundle, except search. This method
  ## accepts Bundles of type `batch` and `transaction`, processing them
  ## according to the [batch processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.1)
  ## and [transaction processing
  ## rules](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.17.2).
  ## 
  ## The request body must contain a JSON-encoded FHIR `Bundle` resource, and
  ## the request headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## For a batch bundle or a successful transaction the response body will
  ## contain a JSON-encoded representation of a `Bundle` resource of type
  ## `batch-response` or `transaction-response` containing one entry for each
  ## entry in the request, with the outcome of processing the entry. In the
  ## case of an error for a transaction bundle, the response body will contain
  ## a JSON-encoded `OperationOutcome` resource describing the reason for the
  ## error. If the request cannot be mapped to a valid API method on a FHIR
  ## store, a generic GCP error might be returned instead.
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
  ##         : Name of the FHIR store in which this bundle will be executed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580484 = newJObject()
  var query_580485 = newJObject()
  var body_580486 = newJObject()
  add(query_580485, "upload_protocol", newJString(uploadProtocol))
  add(query_580485, "fields", newJString(fields))
  add(query_580485, "quotaUser", newJString(quotaUser))
  add(query_580485, "alt", newJString(alt))
  add(query_580485, "oauth_token", newJString(oauthToken))
  add(query_580485, "callback", newJString(callback))
  add(query_580485, "access_token", newJString(accessToken))
  add(query_580485, "uploadType", newJString(uploadType))
  add(path_580484, "parent", newJString(parent))
  add(query_580485, "key", newJString(key))
  add(query_580485, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580486 = body
  add(query_580485, "prettyPrint", newJBool(prettyPrint))
  result = call_580483.call(path_580484, query_580485, nil, nil, body_580486)

var healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580466(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580467,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580468,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580487 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580489(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/Observation/$lastn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580488(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the N most recent `Observation` resources for a subject matching
  ## search criteria specified as query parameters, grouped by
  ## `Observation.code`, sorted from most recent to oldest.
  ## 
  ## Implements the FHIR extended operation
  ## [Observation-lastn](http://hl7.org/implement/standards/fhir/STU3/observation-operations.html#lastn).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method. This operation accepts an additional
  ## query parameter `max`, which specifies N, the maximum number of
  ## Observations to return from each group, with a default of 1.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the FHIR store to retrieve resources from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580490 = path.getOrDefault("parent")
  valid_580490 = validateParameter(valid_580490, JString, required = true,
                                 default = nil)
  if valid_580490 != nil:
    section.add "parent", valid_580490
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
  var valid_580491 = query.getOrDefault("upload_protocol")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "upload_protocol", valid_580491
  var valid_580492 = query.getOrDefault("fields")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "fields", valid_580492
  var valid_580493 = query.getOrDefault("quotaUser")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "quotaUser", valid_580493
  var valid_580494 = query.getOrDefault("alt")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = newJString("json"))
  if valid_580494 != nil:
    section.add "alt", valid_580494
  var valid_580495 = query.getOrDefault("oauth_token")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "oauth_token", valid_580495
  var valid_580496 = query.getOrDefault("callback")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "callback", valid_580496
  var valid_580497 = query.getOrDefault("access_token")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "access_token", valid_580497
  var valid_580498 = query.getOrDefault("uploadType")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "uploadType", valid_580498
  var valid_580499 = query.getOrDefault("key")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "key", valid_580499
  var valid_580500 = query.getOrDefault("$.xgafv")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = newJString("1"))
  if valid_580500 != nil:
    section.add "$.xgafv", valid_580500
  var valid_580501 = query.getOrDefault("prettyPrint")
  valid_580501 = validateParameter(valid_580501, JBool, required = false,
                                 default = newJBool(true))
  if valid_580501 != nil:
    section.add "prettyPrint", valid_580501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580502: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580487;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the N most recent `Observation` resources for a subject matching
  ## search criteria specified as query parameters, grouped by
  ## `Observation.code`, sorted from most recent to oldest.
  ## 
  ## Implements the FHIR extended operation
  ## [Observation-lastn](http://hl7.org/implement/standards/fhir/STU3/observation-operations.html#lastn).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method. This operation accepts an additional
  ## query parameter `max`, which specifies N, the maximum number of
  ## Observations to return from each group, with a default of 1.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_580502.validator(path, query, header, formData, body)
  let scheme = call_580502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580502.url(scheme.get, call_580502.host, call_580502.base,
                         call_580502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580502, url, valid)

proc call*(call_580503: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580487;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn
  ## Retrieves the N most recent `Observation` resources for a subject matching
  ## search criteria specified as query parameters, grouped by
  ## `Observation.code`, sorted from most recent to oldest.
  ## 
  ## Implements the FHIR extended operation
  ## [Observation-lastn](http://hl7.org/implement/standards/fhir/STU3/observation-operations.html#lastn).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method. This operation accepts an additional
  ## query parameter `max`, which specifies N, the maximum number of
  ## Observations to return from each group, with a default of 1.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## operation.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
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
  ##         : Name of the FHIR store to retrieve resources from.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580504 = newJObject()
  var query_580505 = newJObject()
  add(query_580505, "upload_protocol", newJString(uploadProtocol))
  add(query_580505, "fields", newJString(fields))
  add(query_580505, "quotaUser", newJString(quotaUser))
  add(query_580505, "alt", newJString(alt))
  add(query_580505, "oauth_token", newJString(oauthToken))
  add(query_580505, "callback", newJString(callback))
  add(query_580505, "access_token", newJString(accessToken))
  add(query_580505, "uploadType", newJString(uploadType))
  add(path_580504, "parent", newJString(parent))
  add(query_580505, "key", newJString(key))
  add(query_580505, "$.xgafv", newJString(Xgafv))
  add(query_580505, "prettyPrint", newJBool(prettyPrint))
  result = call_580503.call(path_580504, query_580505, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580487(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/Observation/$lastn", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580488,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580489,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580506 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580508(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/_search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580507(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Searches for resources in the given FHIR store according to criteria
  ## specified as query parameters.
  ## 
  ## Implements the FHIR standard [search
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#search)
  ## using the search semantics described in the [FHIR Search
  ## specification](http://hl7.org/implement/standards/fhir/STU3/search.html).
  ## 
  ## Supports three methods of search defined by the specification:
  ## 
  ## *  `GET [base]?[parameters]` to search across all resources.
  ## *  `GET [base]/[type]?[parameters]` to search resources of a specified
  ## type.
  ## *  `POST [base]/[type]/_search?[parameters]` as an alternate form having
  ## the same semantics as the `GET` method.
  ## 
  ## The `GET` methods do not support compartment searches. The `POST` method
  ## does not support `application/x-www-form-urlencoded` search parameters.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## search.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  ## The server's capability statement, retrieved through
  ## capabilities, indicates what search parameters
  ## are supported on each FHIR resource. A list of all search parameters
  ## defined by the specification can be found in the [FHIR Search Parameter
  ## Registry](http://hl7.org/implement/standards/fhir/STU3/searchparameter-registry.html).
  ## 
  ## Supported search modifiers: `:missing`, `:exact`, `:contains`, `:text`,
  ## `:in`, `:not-in`, `:above`, `:below`, `:[type]`, `:not`, and `:recurse`.
  ## 
  ## Supported search result parameters: `_sort`, `_count`, `_include`,
  ## `_revinclude`, `_summary=text`, `_summary=data`, and `_elements`.
  ## 
  ## The maximum number of search results returned defaults to 100, which can
  ## be overridden by the `_count` parameter up to a maximum limit of 1000. If
  ## there are additional results, the returned `Bundle` will contain
  ## pagination links.
  ## 
  ## Resources with a total size larger than 5MB or a field count larger than
  ## 50,000 might not be fully searchable as the server might trim its generated
  ## search index in those cases.
  ## 
  ## Note: FHIR resources are indexed asynchronously, so there might be a slight
  ## delay between the time a resource is created or changes and when the change
  ## is reflected in search results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the FHIR store to retrieve resources from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580509 = path.getOrDefault("parent")
  valid_580509 = validateParameter(valid_580509, JString, required = true,
                                 default = nil)
  if valid_580509 != nil:
    section.add "parent", valid_580509
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
  var valid_580510 = query.getOrDefault("upload_protocol")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "upload_protocol", valid_580510
  var valid_580511 = query.getOrDefault("fields")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "fields", valid_580511
  var valid_580512 = query.getOrDefault("quotaUser")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "quotaUser", valid_580512
  var valid_580513 = query.getOrDefault("alt")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = newJString("json"))
  if valid_580513 != nil:
    section.add "alt", valid_580513
  var valid_580514 = query.getOrDefault("oauth_token")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "oauth_token", valid_580514
  var valid_580515 = query.getOrDefault("callback")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "callback", valid_580515
  var valid_580516 = query.getOrDefault("access_token")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "access_token", valid_580516
  var valid_580517 = query.getOrDefault("uploadType")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "uploadType", valid_580517
  var valid_580518 = query.getOrDefault("key")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "key", valid_580518
  var valid_580519 = query.getOrDefault("$.xgafv")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = newJString("1"))
  if valid_580519 != nil:
    section.add "$.xgafv", valid_580519
  var valid_580520 = query.getOrDefault("prettyPrint")
  valid_580520 = validateParameter(valid_580520, JBool, required = false,
                                 default = newJBool(true))
  if valid_580520 != nil:
    section.add "prettyPrint", valid_580520
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

proc call*(call_580522: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580506;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Searches for resources in the given FHIR store according to criteria
  ## specified as query parameters.
  ## 
  ## Implements the FHIR standard [search
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#search)
  ## using the search semantics described in the [FHIR Search
  ## specification](http://hl7.org/implement/standards/fhir/STU3/search.html).
  ## 
  ## Supports three methods of search defined by the specification:
  ## 
  ## *  `GET [base]?[parameters]` to search across all resources.
  ## *  `GET [base]/[type]?[parameters]` to search resources of a specified
  ## type.
  ## *  `POST [base]/[type]/_search?[parameters]` as an alternate form having
  ## the same semantics as the `GET` method.
  ## 
  ## The `GET` methods do not support compartment searches. The `POST` method
  ## does not support `application/x-www-form-urlencoded` search parameters.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## search.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  ## The server's capability statement, retrieved through
  ## capabilities, indicates what search parameters
  ## are supported on each FHIR resource. A list of all search parameters
  ## defined by the specification can be found in the [FHIR Search Parameter
  ## Registry](http://hl7.org/implement/standards/fhir/STU3/searchparameter-registry.html).
  ## 
  ## Supported search modifiers: `:missing`, `:exact`, `:contains`, `:text`,
  ## `:in`, `:not-in`, `:above`, `:below`, `:[type]`, `:not`, and `:recurse`.
  ## 
  ## Supported search result parameters: `_sort`, `_count`, `_include`,
  ## `_revinclude`, `_summary=text`, `_summary=data`, and `_elements`.
  ## 
  ## The maximum number of search results returned defaults to 100, which can
  ## be overridden by the `_count` parameter up to a maximum limit of 1000. If
  ## there are additional results, the returned `Bundle` will contain
  ## pagination links.
  ## 
  ## Resources with a total size larger than 5MB or a field count larger than
  ## 50,000 might not be fully searchable as the server might trim its generated
  ## search index in those cases.
  ## 
  ## Note: FHIR resources are indexed asynchronously, so there might be a slight
  ## delay between the time a resource is created or changes and when the change
  ## is reflected in search results.
  ## 
  let valid = call_580522.validator(path, query, header, formData, body)
  let scheme = call_580522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580522.url(scheme.get, call_580522.host, call_580522.base,
                         call_580522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580522, url, valid)

proc call*(call_580523: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580506;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirSearch
  ## Searches for resources in the given FHIR store according to criteria
  ## specified as query parameters.
  ## 
  ## Implements the FHIR standard [search
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#search)
  ## using the search semantics described in the [FHIR Search
  ## specification](http://hl7.org/implement/standards/fhir/STU3/search.html).
  ## 
  ## Supports three methods of search defined by the specification:
  ## 
  ## *  `GET [base]?[parameters]` to search across all resources.
  ## *  `GET [base]/[type]?[parameters]` to search resources of a specified
  ## type.
  ## *  `POST [base]/[type]/_search?[parameters]` as an alternate form having
  ## the same semantics as the `GET` method.
  ## 
  ## The `GET` methods do not support compartment searches. The `POST` method
  ## does not support `application/x-www-form-urlencoded` search parameters.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of a `Bundle` resource of type `searchset`, containing the results of the
  ## search.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  ## The server's capability statement, retrieved through
  ## capabilities, indicates what search parameters
  ## are supported on each FHIR resource. A list of all search parameters
  ## defined by the specification can be found in the [FHIR Search Parameter
  ## Registry](http://hl7.org/implement/standards/fhir/STU3/searchparameter-registry.html).
  ## 
  ## Supported search modifiers: `:missing`, `:exact`, `:contains`, `:text`,
  ## `:in`, `:not-in`, `:above`, `:below`, `:[type]`, `:not`, and `:recurse`.
  ## 
  ## Supported search result parameters: `_sort`, `_count`, `_include`,
  ## `_revinclude`, `_summary=text`, `_summary=data`, and `_elements`.
  ## 
  ## The maximum number of search results returned defaults to 100, which can
  ## be overridden by the `_count` parameter up to a maximum limit of 1000. If
  ## there are additional results, the returned `Bundle` will contain
  ## pagination links.
  ## 
  ## Resources with a total size larger than 5MB or a field count larger than
  ## 50,000 might not be fully searchable as the server might trim its generated
  ## search index in those cases.
  ## 
  ## Note: FHIR resources are indexed asynchronously, so there might be a slight
  ## delay between the time a resource is created or changes and when the change
  ## is reflected in search results.
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
  ##         : Name of the FHIR store to retrieve resources from.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580524 = newJObject()
  var query_580525 = newJObject()
  var body_580526 = newJObject()
  add(query_580525, "upload_protocol", newJString(uploadProtocol))
  add(query_580525, "fields", newJString(fields))
  add(query_580525, "quotaUser", newJString(quotaUser))
  add(query_580525, "alt", newJString(alt))
  add(query_580525, "oauth_token", newJString(oauthToken))
  add(query_580525, "callback", newJString(callback))
  add(query_580525, "access_token", newJString(accessToken))
  add(query_580525, "uploadType", newJString(uploadType))
  add(path_580524, "parent", newJString(parent))
  add(query_580525, "key", newJString(key))
  add(query_580525, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580526 = body
  add(query_580525, "prettyPrint", newJBool(prettyPrint))
  result = call_580523.call(path_580524, query_580525, nil, nil, body_580526)

var healthcareProjectsLocationsDatasetsFhirStoresFhirSearch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580506(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirSearch",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/_search", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580507,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580508,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580527 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580529(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580528(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates the entire contents of that resource.
  ## 
  ## Implements the FHIR standard [conditional update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cond-update).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## If the search criteria identify zero matches, and the supplied resource
  ## body contains an `id`, and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID. If the search criteria identify zero
  ## matches, and the supplied resource body does not contain an `id`, the
  ## resource will be created with a server-assigned ID as per the
  ## create method.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The FHIR resource type to update, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ## Must match the resource type in the provided content.
  ##   parent: JString (required)
  ##         : The name of the FHIR store this resource belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_580530 = path.getOrDefault("type")
  valid_580530 = validateParameter(valid_580530, JString, required = true,
                                 default = nil)
  if valid_580530 != nil:
    section.add "type", valid_580530
  var valid_580531 = path.getOrDefault("parent")
  valid_580531 = validateParameter(valid_580531, JString, required = true,
                                 default = nil)
  if valid_580531 != nil:
    section.add "parent", valid_580531
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
  var valid_580532 = query.getOrDefault("upload_protocol")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "upload_protocol", valid_580532
  var valid_580533 = query.getOrDefault("fields")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "fields", valid_580533
  var valid_580534 = query.getOrDefault("quotaUser")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "quotaUser", valid_580534
  var valid_580535 = query.getOrDefault("alt")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = newJString("json"))
  if valid_580535 != nil:
    section.add "alt", valid_580535
  var valid_580536 = query.getOrDefault("oauth_token")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "oauth_token", valid_580536
  var valid_580537 = query.getOrDefault("callback")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "callback", valid_580537
  var valid_580538 = query.getOrDefault("access_token")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "access_token", valid_580538
  var valid_580539 = query.getOrDefault("uploadType")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "uploadType", valid_580539
  var valid_580540 = query.getOrDefault("key")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "key", valid_580540
  var valid_580541 = query.getOrDefault("$.xgafv")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = newJString("1"))
  if valid_580541 != nil:
    section.add "$.xgafv", valid_580541
  var valid_580542 = query.getOrDefault("prettyPrint")
  valid_580542 = validateParameter(valid_580542, JBool, required = false,
                                 default = newJBool(true))
  if valid_580542 != nil:
    section.add "prettyPrint", valid_580542
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

proc call*(call_580544: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580527;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates the entire contents of that resource.
  ## 
  ## Implements the FHIR standard [conditional update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cond-update).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## If the search criteria identify zero matches, and the supplied resource
  ## body contains an `id`, and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID. If the search criteria identify zero
  ## matches, and the supplied resource body does not contain an `id`, the
  ## resource will be created with a server-assigned ID as per the
  ## create method.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_580544.validator(path, query, header, formData, body)
  let scheme = call_580544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580544.url(scheme.get, call_580544.host, call_580544.base,
                         call_580544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580544, url, valid)

proc call*(call_580545: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580527;
          `type`: string; parent: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates the entire contents of that resource.
  ## 
  ## Implements the FHIR standard [conditional update
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cond-update).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## If the search criteria identify zero matches, and the supplied resource
  ## body contains an `id`, and the FHIR store has
  ## enable_update_create set, creates the
  ## resource with the client-specified ID. If the search criteria identify zero
  ## matches, and the supplied resource body does not contain an `id`, the
  ## resource will be created with a server-assigned ID as per the
  ## create method.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   type: string (required)
  ##       : The FHIR resource type to update, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ## Must match the resource type in the provided content.
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
  ##         : The name of the FHIR store this resource belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580546 = newJObject()
  var query_580547 = newJObject()
  var body_580548 = newJObject()
  add(path_580546, "type", newJString(`type`))
  add(query_580547, "upload_protocol", newJString(uploadProtocol))
  add(query_580547, "fields", newJString(fields))
  add(query_580547, "quotaUser", newJString(quotaUser))
  add(query_580547, "alt", newJString(alt))
  add(query_580547, "oauth_token", newJString(oauthToken))
  add(query_580547, "callback", newJString(callback))
  add(query_580547, "access_token", newJString(accessToken))
  add(query_580547, "uploadType", newJString(uploadType))
  add(path_580546, "parent", newJString(parent))
  add(query_580547, "key", newJString(key))
  add(query_580547, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580548 = body
  add(query_580547, "prettyPrint", newJBool(prettyPrint))
  result = call_580545.call(path_580546, query_580547, nil, nil, body_580548)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580527(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate",
    meth: HttpMethod.HttpPut, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580528,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580529,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580549 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580551(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580550(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a FHIR resource.
  ## 
  ## Implements the FHIR standard [create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#create),
  ## which creates a new resource with a server-assigned resource ID.
  ## 
  ## Also supports the FHIR standard [conditional create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#ccreate),
  ## specified by supplying an `If-None-Exist` header containing a FHIR search
  ## query. If no resources match this search query, the server processes the
  ## create operation as normal.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource as it was created on the server, including the
  ## server-assigned resource ID and version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The FHIR resource type to create, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ## Must match the resource type in the provided content.
  ##   parent: JString (required)
  ##         : The name of the FHIR store this resource belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_580552 = path.getOrDefault("type")
  valid_580552 = validateParameter(valid_580552, JString, required = true,
                                 default = nil)
  if valid_580552 != nil:
    section.add "type", valid_580552
  var valid_580553 = path.getOrDefault("parent")
  valid_580553 = validateParameter(valid_580553, JString, required = true,
                                 default = nil)
  if valid_580553 != nil:
    section.add "parent", valid_580553
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
  var valid_580554 = query.getOrDefault("upload_protocol")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "upload_protocol", valid_580554
  var valid_580555 = query.getOrDefault("fields")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "fields", valid_580555
  var valid_580556 = query.getOrDefault("quotaUser")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "quotaUser", valid_580556
  var valid_580557 = query.getOrDefault("alt")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = newJString("json"))
  if valid_580557 != nil:
    section.add "alt", valid_580557
  var valid_580558 = query.getOrDefault("oauth_token")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "oauth_token", valid_580558
  var valid_580559 = query.getOrDefault("callback")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "callback", valid_580559
  var valid_580560 = query.getOrDefault("access_token")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "access_token", valid_580560
  var valid_580561 = query.getOrDefault("uploadType")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "uploadType", valid_580561
  var valid_580562 = query.getOrDefault("key")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "key", valid_580562
  var valid_580563 = query.getOrDefault("$.xgafv")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = newJString("1"))
  if valid_580563 != nil:
    section.add "$.xgafv", valid_580563
  var valid_580564 = query.getOrDefault("prettyPrint")
  valid_580564 = validateParameter(valid_580564, JBool, required = false,
                                 default = newJBool(true))
  if valid_580564 != nil:
    section.add "prettyPrint", valid_580564
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

proc call*(call_580566: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580549;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a FHIR resource.
  ## 
  ## Implements the FHIR standard [create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#create),
  ## which creates a new resource with a server-assigned resource ID.
  ## 
  ## Also supports the FHIR standard [conditional create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#ccreate),
  ## specified by supplying an `If-None-Exist` header containing a FHIR search
  ## query. If no resources match this search query, the server processes the
  ## create operation as normal.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource as it was created on the server, including the
  ## server-assigned resource ID and version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_580566.validator(path, query, header, formData, body)
  let scheme = call_580566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580566.url(scheme.get, call_580566.host, call_580566.base,
                         call_580566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580566, url, valid)

proc call*(call_580567: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580549;
          `type`: string; parent: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirCreate
  ## Creates a FHIR resource.
  ## 
  ## Implements the FHIR standard [create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#create),
  ## which creates a new resource with a server-assigned resource ID.
  ## 
  ## Also supports the FHIR standard [conditional create
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#ccreate),
  ## specified by supplying an `If-None-Exist` header containing a FHIR search
  ## query. If no resources match this search query, the server processes the
  ## create operation as normal.
  ## 
  ## The request body must contain a JSON-encoded FHIR resource, and the request
  ## headers must contain `Content-Type: application/fhir+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource as it was created on the server, including the
  ## server-assigned resource ID and version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   type: string (required)
  ##       : The FHIR resource type to create, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ## Must match the resource type in the provided content.
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
  ##         : The name of the FHIR store this resource belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580568 = newJObject()
  var query_580569 = newJObject()
  var body_580570 = newJObject()
  add(path_580568, "type", newJString(`type`))
  add(query_580569, "upload_protocol", newJString(uploadProtocol))
  add(query_580569, "fields", newJString(fields))
  add(query_580569, "quotaUser", newJString(quotaUser))
  add(query_580569, "alt", newJString(alt))
  add(query_580569, "oauth_token", newJString(oauthToken))
  add(query_580569, "callback", newJString(callback))
  add(query_580569, "access_token", newJString(accessToken))
  add(query_580569, "uploadType", newJString(uploadType))
  add(path_580568, "parent", newJString(parent))
  add(query_580569, "key", newJString(key))
  add(query_580569, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580570 = body
  add(query_580569, "prettyPrint", newJBool(prettyPrint))
  result = call_580567.call(path_580568, query_580569, nil, nil, body_580570)

var healthcareProjectsLocationsDatasetsFhirStoresFhirCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580549(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580550,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580551,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580591 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580593(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580592(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates part of that resource by applying the operations
  ## specified in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [conditional patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## 
  ## The request body must contain a JSON Patch document, and the request
  ## headers must contain `Content-Type: application/json-patch+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The FHIR resource type to update, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ##   parent: JString (required)
  ##         : The name of the FHIR store this resource belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_580594 = path.getOrDefault("type")
  valid_580594 = validateParameter(valid_580594, JString, required = true,
                                 default = nil)
  if valid_580594 != nil:
    section.add "type", valid_580594
  var valid_580595 = path.getOrDefault("parent")
  valid_580595 = validateParameter(valid_580595, JString, required = true,
                                 default = nil)
  if valid_580595 != nil:
    section.add "parent", valid_580595
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
  var valid_580596 = query.getOrDefault("upload_protocol")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "upload_protocol", valid_580596
  var valid_580597 = query.getOrDefault("fields")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "fields", valid_580597
  var valid_580598 = query.getOrDefault("quotaUser")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "quotaUser", valid_580598
  var valid_580599 = query.getOrDefault("alt")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = newJString("json"))
  if valid_580599 != nil:
    section.add "alt", valid_580599
  var valid_580600 = query.getOrDefault("oauth_token")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "oauth_token", valid_580600
  var valid_580601 = query.getOrDefault("callback")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "callback", valid_580601
  var valid_580602 = query.getOrDefault("access_token")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = nil)
  if valid_580602 != nil:
    section.add "access_token", valid_580602
  var valid_580603 = query.getOrDefault("uploadType")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "uploadType", valid_580603
  var valid_580604 = query.getOrDefault("key")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "key", valid_580604
  var valid_580605 = query.getOrDefault("$.xgafv")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = newJString("1"))
  if valid_580605 != nil:
    section.add "$.xgafv", valid_580605
  var valid_580606 = query.getOrDefault("prettyPrint")
  valid_580606 = validateParameter(valid_580606, JBool, required = false,
                                 default = newJBool(true))
  if valid_580606 != nil:
    section.add "prettyPrint", valid_580606
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

proc call*(call_580608: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580591;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates part of that resource by applying the operations
  ## specified in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [conditional patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## 
  ## The request body must contain a JSON Patch document, and the request
  ## headers must contain `Content-Type: application/json-patch+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_580608.validator(path, query, header, formData, body)
  let scheme = call_580608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580608.url(scheme.get, call_580608.host, call_580608.base,
                         call_580608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580608, url, valid)

proc call*(call_580609: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580591;
          `type`: string; parent: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch
  ## If a resource is found based on the search criteria specified in the query
  ## parameters, updates part of that resource by applying the operations
  ## specified in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [conditional patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## If the search criteria identify more than one match, the request will
  ## return a `412 Precondition Failed` error.
  ## 
  ## The request body must contain a JSON Patch document, and the request
  ## headers must contain `Content-Type: application/json-patch+json`.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the updated resource, including the server-assigned version ID.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   type: string (required)
  ##       : The FHIR resource type to update, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
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
  ##         : The name of the FHIR store this resource belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580610 = newJObject()
  var query_580611 = newJObject()
  var body_580612 = newJObject()
  add(path_580610, "type", newJString(`type`))
  add(query_580611, "upload_protocol", newJString(uploadProtocol))
  add(query_580611, "fields", newJString(fields))
  add(query_580611, "quotaUser", newJString(quotaUser))
  add(query_580611, "alt", newJString(alt))
  add(query_580611, "oauth_token", newJString(oauthToken))
  add(query_580611, "callback", newJString(callback))
  add(query_580611, "access_token", newJString(accessToken))
  add(query_580611, "uploadType", newJString(uploadType))
  add(path_580610, "parent", newJString(parent))
  add(query_580611, "key", newJString(key))
  add(query_580611, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580612 = body
  add(query_580611, "prettyPrint", newJBool(prettyPrint))
  result = call_580609.call(path_580610, query_580611, nil, nil, body_580612)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580591(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580592,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580593,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580571 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580573(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580572(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes FHIR resources that match a search query.
  ## 
  ## Implements the FHIR standard [conditional delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.13.1).
  ## If multiple resources match, all of them will be deleted.
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## Note: Unless resource versioning is disabled by setting the
  ## disable_resource_versioning flag
  ## on the FHIR store, the deleted resources will be moved to a history
  ## repository that can still be retrieved through vread
  ## and related methods, unless they are removed by the
  ## purge method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The FHIR resource type to delete, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
  ##   parent: JString (required)
  ##         : The name of the FHIR store this resource belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_580574 = path.getOrDefault("type")
  valid_580574 = validateParameter(valid_580574, JString, required = true,
                                 default = nil)
  if valid_580574 != nil:
    section.add "type", valid_580574
  var valid_580575 = path.getOrDefault("parent")
  valid_580575 = validateParameter(valid_580575, JString, required = true,
                                 default = nil)
  if valid_580575 != nil:
    section.add "parent", valid_580575
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
  var valid_580576 = query.getOrDefault("upload_protocol")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "upload_protocol", valid_580576
  var valid_580577 = query.getOrDefault("fields")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "fields", valid_580577
  var valid_580578 = query.getOrDefault("quotaUser")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "quotaUser", valid_580578
  var valid_580579 = query.getOrDefault("alt")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = newJString("json"))
  if valid_580579 != nil:
    section.add "alt", valid_580579
  var valid_580580 = query.getOrDefault("oauth_token")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "oauth_token", valid_580580
  var valid_580581 = query.getOrDefault("callback")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "callback", valid_580581
  var valid_580582 = query.getOrDefault("access_token")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "access_token", valid_580582
  var valid_580583 = query.getOrDefault("uploadType")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "uploadType", valid_580583
  var valid_580584 = query.getOrDefault("key")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "key", valid_580584
  var valid_580585 = query.getOrDefault("$.xgafv")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = newJString("1"))
  if valid_580585 != nil:
    section.add "$.xgafv", valid_580585
  var valid_580586 = query.getOrDefault("prettyPrint")
  valid_580586 = validateParameter(valid_580586, JBool, required = false,
                                 default = newJBool(true))
  if valid_580586 != nil:
    section.add "prettyPrint", valid_580586
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580587: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580571;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes FHIR resources that match a search query.
  ## 
  ## Implements the FHIR standard [conditional delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.13.1).
  ## If multiple resources match, all of them will be deleted.
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## Note: Unless resource versioning is disabled by setting the
  ## disable_resource_versioning flag
  ## on the FHIR store, the deleted resources will be moved to a history
  ## repository that can still be retrieved through vread
  ## and related methods, unless they are removed by the
  ## purge method.
  ## 
  let valid = call_580587.validator(path, query, header, formData, body)
  let scheme = call_580587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580587.url(scheme.get, call_580587.host, call_580587.base,
                         call_580587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580587, url, valid)

proc call*(call_580588: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580571;
          `type`: string; parent: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete
  ## Deletes FHIR resources that match a search query.
  ## 
  ## Implements the FHIR standard [conditional delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#2.21.0.13.1).
  ## If multiple resources match, all of them will be deleted.
  ## 
  ## Search terms are provided as query parameters following the same pattern as
  ## the search method.
  ## 
  ## Note: Unless resource versioning is disabled by setting the
  ## disable_resource_versioning flag
  ## on the FHIR store, the deleted resources will be moved to a history
  ## repository that can still be retrieved through vread
  ## and related methods, unless they are removed by the
  ## purge method.
  ##   type: string (required)
  ##       : The FHIR resource type to delete, such as Patient or Observation. For a
  ## complete list, see the [FHIR Resource
  ## Index](http://hl7.org/implement/standards/fhir/STU3/resourcelist.html).
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
  ##         : The name of the FHIR store this resource belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580589 = newJObject()
  var query_580590 = newJObject()
  add(path_580589, "type", newJString(`type`))
  add(query_580590, "upload_protocol", newJString(uploadProtocol))
  add(query_580590, "fields", newJString(fields))
  add(query_580590, "quotaUser", newJString(quotaUser))
  add(query_580590, "alt", newJString(alt))
  add(query_580590, "oauth_token", newJString(oauthToken))
  add(query_580590, "callback", newJString(callback))
  add(query_580590, "access_token", newJString(accessToken))
  add(query_580590, "uploadType", newJString(uploadType))
  add(path_580589, "parent", newJString(parent))
  add(query_580590, "key", newJString(key))
  add(query_580590, "$.xgafv", newJString(Xgafv))
  add(query_580590, "prettyPrint", newJBool(prettyPrint))
  result = call_580588.call(path_580589, query_580590, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580571(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580572,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580573,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580635 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580637(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhirStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580636(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new FHIR store within the parent dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this FHIR store belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580638 = path.getOrDefault("parent")
  valid_580638 = validateParameter(valid_580638, JString, required = true,
                                 default = nil)
  if valid_580638 != nil:
    section.add "parent", valid_580638
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
  ##   fhirStoreId: JString
  ##              : The ID of the FHIR store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580639 = query.getOrDefault("upload_protocol")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "upload_protocol", valid_580639
  var valid_580640 = query.getOrDefault("fields")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = nil)
  if valid_580640 != nil:
    section.add "fields", valid_580640
  var valid_580641 = query.getOrDefault("quotaUser")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "quotaUser", valid_580641
  var valid_580642 = query.getOrDefault("alt")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = newJString("json"))
  if valid_580642 != nil:
    section.add "alt", valid_580642
  var valid_580643 = query.getOrDefault("oauth_token")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "oauth_token", valid_580643
  var valid_580644 = query.getOrDefault("callback")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "callback", valid_580644
  var valid_580645 = query.getOrDefault("access_token")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "access_token", valid_580645
  var valid_580646 = query.getOrDefault("uploadType")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "uploadType", valid_580646
  var valid_580647 = query.getOrDefault("fhirStoreId")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "fhirStoreId", valid_580647
  var valid_580648 = query.getOrDefault("key")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "key", valid_580648
  var valid_580649 = query.getOrDefault("$.xgafv")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = newJString("1"))
  if valid_580649 != nil:
    section.add "$.xgafv", valid_580649
  var valid_580650 = query.getOrDefault("prettyPrint")
  valid_580650 = validateParameter(valid_580650, JBool, required = false,
                                 default = newJBool(true))
  if valid_580650 != nil:
    section.add "prettyPrint", valid_580650
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

proc call*(call_580652: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new FHIR store within the parent dataset.
  ## 
  let valid = call_580652.validator(path, query, header, formData, body)
  let scheme = call_580652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580652.url(scheme.get, call_580652.host, call_580652.base,
                         call_580652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580652, url, valid)

proc call*(call_580653: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580635;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          fhirStoreId: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresCreate
  ## Creates a new FHIR store within the parent dataset.
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
  ##         : The name of the dataset this FHIR store belongs to.
  ##   fhirStoreId: string
  ##              : The ID of the FHIR store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580654 = newJObject()
  var query_580655 = newJObject()
  var body_580656 = newJObject()
  add(query_580655, "upload_protocol", newJString(uploadProtocol))
  add(query_580655, "fields", newJString(fields))
  add(query_580655, "quotaUser", newJString(quotaUser))
  add(query_580655, "alt", newJString(alt))
  add(query_580655, "oauth_token", newJString(oauthToken))
  add(query_580655, "callback", newJString(callback))
  add(query_580655, "access_token", newJString(accessToken))
  add(query_580655, "uploadType", newJString(uploadType))
  add(path_580654, "parent", newJString(parent))
  add(query_580655, "fhirStoreId", newJString(fhirStoreId))
  add(query_580655, "key", newJString(key))
  add(query_580655, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580656 = body
  add(query_580655, "prettyPrint", newJBool(prettyPrint))
  result = call_580653.call(path_580654, query_580655, nil, nil, body_580656)

var healthcareProjectsLocationsDatasetsFhirStoresCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580635(
    name: "healthcareProjectsLocationsDatasetsFhirStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580636,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580637,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresList_580613 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresList_580615(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhirStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresList_580614(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the FHIR stores in the given dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the dataset.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580616 = path.getOrDefault("parent")
  valid_580616 = validateParameter(valid_580616, JString, required = true,
                                 default = nil)
  if valid_580616 != nil:
    section.add "parent", valid_580616
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##           : Limit on the number of FHIR stores to return in a single response.  If zero
  ## the default page size of 100 is used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  section = newJObject()
  var valid_580617 = query.getOrDefault("upload_protocol")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "upload_protocol", valid_580617
  var valid_580618 = query.getOrDefault("fields")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "fields", valid_580618
  var valid_580619 = query.getOrDefault("pageToken")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "pageToken", valid_580619
  var valid_580620 = query.getOrDefault("quotaUser")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "quotaUser", valid_580620
  var valid_580621 = query.getOrDefault("alt")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = newJString("json"))
  if valid_580621 != nil:
    section.add "alt", valid_580621
  var valid_580622 = query.getOrDefault("oauth_token")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "oauth_token", valid_580622
  var valid_580623 = query.getOrDefault("callback")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "callback", valid_580623
  var valid_580624 = query.getOrDefault("access_token")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "access_token", valid_580624
  var valid_580625 = query.getOrDefault("uploadType")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "uploadType", valid_580625
  var valid_580626 = query.getOrDefault("key")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "key", valid_580626
  var valid_580627 = query.getOrDefault("$.xgafv")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = newJString("1"))
  if valid_580627 != nil:
    section.add "$.xgafv", valid_580627
  var valid_580628 = query.getOrDefault("pageSize")
  valid_580628 = validateParameter(valid_580628, JInt, required = false, default = nil)
  if valid_580628 != nil:
    section.add "pageSize", valid_580628
  var valid_580629 = query.getOrDefault("prettyPrint")
  valid_580629 = validateParameter(valid_580629, JBool, required = false,
                                 default = newJBool(true))
  if valid_580629 != nil:
    section.add "prettyPrint", valid_580629
  var valid_580630 = query.getOrDefault("filter")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "filter", valid_580630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580631: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_580613;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the FHIR stores in the given dataset.
  ## 
  let valid = call_580631.validator(path, query, header, formData, body)
  let scheme = call_580631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580631.url(scheme.get, call_580631.host, call_580631.base,
                         call_580631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580631, url, valid)

proc call*(call_580632: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_580613;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresList
  ## Lists the FHIR stores in the given dataset.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##         : Name of the dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of FHIR stores to return in a single response.  If zero
  ## the default page size of 100 is used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  var path_580633 = newJObject()
  var query_580634 = newJObject()
  add(query_580634, "upload_protocol", newJString(uploadProtocol))
  add(query_580634, "fields", newJString(fields))
  add(query_580634, "pageToken", newJString(pageToken))
  add(query_580634, "quotaUser", newJString(quotaUser))
  add(query_580634, "alt", newJString(alt))
  add(query_580634, "oauth_token", newJString(oauthToken))
  add(query_580634, "callback", newJString(callback))
  add(query_580634, "access_token", newJString(accessToken))
  add(query_580634, "uploadType", newJString(uploadType))
  add(path_580633, "parent", newJString(parent))
  add(query_580634, "key", newJString(key))
  add(query_580634, "$.xgafv", newJString(Xgafv))
  add(query_580634, "pageSize", newJInt(pageSize))
  add(query_580634, "prettyPrint", newJBool(prettyPrint))
  add(query_580634, "filter", newJString(filter))
  result = call_580632.call(path_580633, query_580634, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresList* = Call_HealthcareProjectsLocationsDatasetsFhirStoresList_580613(
    name: "healthcareProjectsLocationsDatasetsFhirStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresList_580614,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresList_580615,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580679 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580681(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/hl7V2Stores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580680(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new HL7v2 store within the parent dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this HL7v2 store belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580682 = path.getOrDefault("parent")
  valid_580682 = validateParameter(valid_580682, JString, required = true,
                                 default = nil)
  if valid_580682 != nil:
    section.add "parent", valid_580682
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
  ##   hl7V2StoreId: JString
  ##               : The ID of the HL7v2 store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580683 = query.getOrDefault("upload_protocol")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "upload_protocol", valid_580683
  var valid_580684 = query.getOrDefault("fields")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "fields", valid_580684
  var valid_580685 = query.getOrDefault("quotaUser")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "quotaUser", valid_580685
  var valid_580686 = query.getOrDefault("alt")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = newJString("json"))
  if valid_580686 != nil:
    section.add "alt", valid_580686
  var valid_580687 = query.getOrDefault("oauth_token")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "oauth_token", valid_580687
  var valid_580688 = query.getOrDefault("callback")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "callback", valid_580688
  var valid_580689 = query.getOrDefault("access_token")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "access_token", valid_580689
  var valid_580690 = query.getOrDefault("uploadType")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "uploadType", valid_580690
  var valid_580691 = query.getOrDefault("hl7V2StoreId")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "hl7V2StoreId", valid_580691
  var valid_580692 = query.getOrDefault("key")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "key", valid_580692
  var valid_580693 = query.getOrDefault("$.xgafv")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = newJString("1"))
  if valid_580693 != nil:
    section.add "$.xgafv", valid_580693
  var valid_580694 = query.getOrDefault("prettyPrint")
  valid_580694 = validateParameter(valid_580694, JBool, required = false,
                                 default = newJBool(true))
  if valid_580694 != nil:
    section.add "prettyPrint", valid_580694
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

proc call*(call_580696: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new HL7v2 store within the parent dataset.
  ## 
  let valid = call_580696.validator(path, query, header, formData, body)
  let scheme = call_580696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580696.url(scheme.get, call_580696.host, call_580696.base,
                         call_580696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580696, url, valid)

proc call*(call_580697: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580679;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          hl7V2StoreId: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresCreate
  ## Creates a new HL7v2 store within the parent dataset.
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
  ##         : The name of the dataset this HL7v2 store belongs to.
  ##   hl7V2StoreId: string
  ##               : The ID of the HL7v2 store that is being created.
  ## The string must match the following regex: `[\p{L}\p{N}_\-\.]{1,256}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580698 = newJObject()
  var query_580699 = newJObject()
  var body_580700 = newJObject()
  add(query_580699, "upload_protocol", newJString(uploadProtocol))
  add(query_580699, "fields", newJString(fields))
  add(query_580699, "quotaUser", newJString(quotaUser))
  add(query_580699, "alt", newJString(alt))
  add(query_580699, "oauth_token", newJString(oauthToken))
  add(query_580699, "callback", newJString(callback))
  add(query_580699, "access_token", newJString(accessToken))
  add(query_580699, "uploadType", newJString(uploadType))
  add(path_580698, "parent", newJString(parent))
  add(query_580699, "hl7V2StoreId", newJString(hl7V2StoreId))
  add(query_580699, "key", newJString(key))
  add(query_580699, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580700 = body
  add(query_580699, "prettyPrint", newJBool(prettyPrint))
  result = call_580697.call(path_580698, query_580699, nil, nil, body_580700)

var healthcareProjectsLocationsDatasetsHl7V2StoresCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580679(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580680,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580681,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580657 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580659(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/hl7V2Stores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580658(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the HL7v2 stores in the given dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the dataset.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580660 = path.getOrDefault("parent")
  valid_580660 = validateParameter(valid_580660, JString, required = true,
                                 default = nil)
  if valid_580660 != nil:
    section.add "parent", valid_580660
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##           : Limit on the number of HL7v2 stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  section = newJObject()
  var valid_580661 = query.getOrDefault("upload_protocol")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "upload_protocol", valid_580661
  var valid_580662 = query.getOrDefault("fields")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "fields", valid_580662
  var valid_580663 = query.getOrDefault("pageToken")
  valid_580663 = validateParameter(valid_580663, JString, required = false,
                                 default = nil)
  if valid_580663 != nil:
    section.add "pageToken", valid_580663
  var valid_580664 = query.getOrDefault("quotaUser")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "quotaUser", valid_580664
  var valid_580665 = query.getOrDefault("alt")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = newJString("json"))
  if valid_580665 != nil:
    section.add "alt", valid_580665
  var valid_580666 = query.getOrDefault("oauth_token")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "oauth_token", valid_580666
  var valid_580667 = query.getOrDefault("callback")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "callback", valid_580667
  var valid_580668 = query.getOrDefault("access_token")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "access_token", valid_580668
  var valid_580669 = query.getOrDefault("uploadType")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "uploadType", valid_580669
  var valid_580670 = query.getOrDefault("key")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "key", valid_580670
  var valid_580671 = query.getOrDefault("$.xgafv")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = newJString("1"))
  if valid_580671 != nil:
    section.add "$.xgafv", valid_580671
  var valid_580672 = query.getOrDefault("pageSize")
  valid_580672 = validateParameter(valid_580672, JInt, required = false, default = nil)
  if valid_580672 != nil:
    section.add "pageSize", valid_580672
  var valid_580673 = query.getOrDefault("prettyPrint")
  valid_580673 = validateParameter(valid_580673, JBool, required = false,
                                 default = newJBool(true))
  if valid_580673 != nil:
    section.add "prettyPrint", valid_580673
  var valid_580674 = query.getOrDefault("filter")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "filter", valid_580674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580675: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580657;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the HL7v2 stores in the given dataset.
  ## 
  let valid = call_580675.validator(path, query, header, formData, body)
  let scheme = call_580675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580675.url(scheme.get, call_580675.host, call_580675.base,
                         call_580675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580675, url, valid)

proc call*(call_580676: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580657;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresList
  ## Lists the HL7v2 stores in the given dataset.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##         : Name of the dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of HL7v2 stores to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Restricts stores returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## Only filtering on labels is supported, for example `labels.key=value`.
  var path_580677 = newJObject()
  var query_580678 = newJObject()
  add(query_580678, "upload_protocol", newJString(uploadProtocol))
  add(query_580678, "fields", newJString(fields))
  add(query_580678, "pageToken", newJString(pageToken))
  add(query_580678, "quotaUser", newJString(quotaUser))
  add(query_580678, "alt", newJString(alt))
  add(query_580678, "oauth_token", newJString(oauthToken))
  add(query_580678, "callback", newJString(callback))
  add(query_580678, "access_token", newJString(accessToken))
  add(query_580678, "uploadType", newJString(uploadType))
  add(path_580677, "parent", newJString(parent))
  add(query_580678, "key", newJString(key))
  add(query_580678, "$.xgafv", newJString(Xgafv))
  add(query_580678, "pageSize", newJInt(pageSize))
  add(query_580678, "prettyPrint", newJBool(prettyPrint))
  add(query_580678, "filter", newJString(filter))
  result = call_580676.call(path_580677, query_580678, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580657(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580658,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580659,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580724 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580726(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580725(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a message and sends a notification to the Cloud Pub/Sub topic. If
  ## configured, the MLLP adapter listens to messages created by this method and
  ## sends those back to the hospital. A successful response indicates the
  ## message has been persisted to storage and a Cloud Pub/Sub notification has
  ## been sent. Sending to the hospital by the MLLP adapter happens
  ## asynchronously.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the dataset this message belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580727 = path.getOrDefault("parent")
  valid_580727 = validateParameter(valid_580727, JString, required = true,
                                 default = nil)
  if valid_580727 != nil:
    section.add "parent", valid_580727
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
  var valid_580728 = query.getOrDefault("upload_protocol")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "upload_protocol", valid_580728
  var valid_580729 = query.getOrDefault("fields")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = nil)
  if valid_580729 != nil:
    section.add "fields", valid_580729
  var valid_580730 = query.getOrDefault("quotaUser")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "quotaUser", valid_580730
  var valid_580731 = query.getOrDefault("alt")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = newJString("json"))
  if valid_580731 != nil:
    section.add "alt", valid_580731
  var valid_580732 = query.getOrDefault("oauth_token")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "oauth_token", valid_580732
  var valid_580733 = query.getOrDefault("callback")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "callback", valid_580733
  var valid_580734 = query.getOrDefault("access_token")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "access_token", valid_580734
  var valid_580735 = query.getOrDefault("uploadType")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "uploadType", valid_580735
  var valid_580736 = query.getOrDefault("key")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "key", valid_580736
  var valid_580737 = query.getOrDefault("$.xgafv")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = newJString("1"))
  if valid_580737 != nil:
    section.add "$.xgafv", valid_580737
  var valid_580738 = query.getOrDefault("prettyPrint")
  valid_580738 = validateParameter(valid_580738, JBool, required = false,
                                 default = newJBool(true))
  if valid_580738 != nil:
    section.add "prettyPrint", valid_580738
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

proc call*(call_580740: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580724;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a message and sends a notification to the Cloud Pub/Sub topic. If
  ## configured, the MLLP adapter listens to messages created by this method and
  ## sends those back to the hospital. A successful response indicates the
  ## message has been persisted to storage and a Cloud Pub/Sub notification has
  ## been sent. Sending to the hospital by the MLLP adapter happens
  ## asynchronously.
  ## 
  let valid = call_580740.validator(path, query, header, formData, body)
  let scheme = call_580740.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580740.url(scheme.get, call_580740.host, call_580740.base,
                         call_580740.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580740, url, valid)

proc call*(call_580741: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580724;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate
  ## Creates a message and sends a notification to the Cloud Pub/Sub topic. If
  ## configured, the MLLP adapter listens to messages created by this method and
  ## sends those back to the hospital. A successful response indicates the
  ## message has been persisted to storage and a Cloud Pub/Sub notification has
  ## been sent. Sending to the hospital by the MLLP adapter happens
  ## asynchronously.
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
  ##         : The name of the dataset this message belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580742 = newJObject()
  var query_580743 = newJObject()
  var body_580744 = newJObject()
  add(query_580743, "upload_protocol", newJString(uploadProtocol))
  add(query_580743, "fields", newJString(fields))
  add(query_580743, "quotaUser", newJString(quotaUser))
  add(query_580743, "alt", newJString(alt))
  add(query_580743, "oauth_token", newJString(oauthToken))
  add(query_580743, "callback", newJString(callback))
  add(query_580743, "access_token", newJString(accessToken))
  add(query_580743, "uploadType", newJString(uploadType))
  add(path_580742, "parent", newJString(parent))
  add(query_580743, "key", newJString(key))
  add(query_580743, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580744 = body
  add(query_580743, "prettyPrint", newJBool(prettyPrint))
  result = call_580741.call(path_580742, query_580743, nil, nil, body_580744)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580724(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580725,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580726,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580701 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580703(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580702(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the messages in the given HL7v2 store with support for filtering.
  ## 
  ## Note: HL7v2 messages are indexed asynchronously, so there might be a slight
  ## delay between the time a message is created and when it can be found
  ## through a filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the HL7v2 store to retrieve messages from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580704 = path.getOrDefault("parent")
  valid_580704 = validateParameter(valid_580704, JString, required = true,
                                 default = nil)
  if valid_580704 != nil:
    section.add "parent", valid_580704
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##   orderBy: JString
  ##          : Orders messages returned by the specified order_by clause.
  ## Syntax: https://cloud.google.com/apis/design/design_patterns#sorting_order
  ## 
  ## Fields available for ordering are:
  ## 
  ## *  `send_time`
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Limit on the number of messages to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Restricts messages returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## 
  ## Fields/functions available for filtering are:
  ## 
  ## *  `message_type`, from the MSH-9 segment; for example
  ## `NOT message_type = "ADT"`
  ## *  `send_date` or `sendDate`, the YYYY-MM-DD date the message was sent in
  ## the dataset's time_zone, from the MSH-7 segment; for example
  ## `send_date < "2017-01-02"`
  ## *  `send_time`, the timestamp when the message was sent, using the
  ## RFC3339 time format for comparisons, from the MSH-7 segment; for example
  ## `send_time < "2017-01-02T00:00:00-05:00"`
  ## *  `send_facility`, the care center that the message came from, from the
  ## MSH-4 segment; for example `send_facility = "ABC"`
  ## *  `HL7RegExp(expr)`, which does regular expression matching of `expr`
  ## against the message payload using re2 (http://code.google.com/p/re2/)
  ## syntax; for example `HL7RegExp("^.*\|.*\|EMERG")`
  ## *  `PatientId(value, type)`, which matches if the message lists a patient
  ## having an ID of the given value and type in the PID-2, PID-3, or PID-4
  ## segments; for example `PatientId("123456", "MRN")`
  ## *  `labels.x`, a string value of the label with key `x` as set using the
  ## Message.labels
  ## map, for example `labels."priority"="high"`. The operator `:*` can be used
  ## to assert the existence of a label, for example `labels."priority":*`.
  ## 
  ## Limitations on conjunctions:
  ## 
  ## *  Negation on the patient ID function or the labels field is not
  ## supported, for example these queries are invalid:
  ## `NOT PatientId("123456", "MRN")`, `NOT labels."tag1":*`,
  ## `NOT labels."tag2"="val2"`.
  ## *  Conjunction of multiple patient ID functions is not supported, for
  ## example this query is invalid:
  ## `PatientId("123456", "MRN") AND PatientId("456789", "MRN")`.
  ## *  Conjunction of multiple labels fields is also not supported, for
  ## example this query is invalid: `labels."tag1":* AND labels."tag2"="val2"`.
  ## *  Conjunction of one patient ID function, one labels field and conditions
  ## on other fields is supported, for example this query is valid:
  ## `PatientId("123456", "MRN") AND labels."tag1":* AND message_type = "ADT"`.
  ## 
  ## The HasLabel(x) and Label(x) syntax from previous API versions are
  ## deprecated; replaced by the `labels.x` syntax.
  section = newJObject()
  var valid_580705 = query.getOrDefault("upload_protocol")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "upload_protocol", valid_580705
  var valid_580706 = query.getOrDefault("fields")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "fields", valid_580706
  var valid_580707 = query.getOrDefault("pageToken")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "pageToken", valid_580707
  var valid_580708 = query.getOrDefault("quotaUser")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "quotaUser", valid_580708
  var valid_580709 = query.getOrDefault("alt")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = newJString("json"))
  if valid_580709 != nil:
    section.add "alt", valid_580709
  var valid_580710 = query.getOrDefault("oauth_token")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "oauth_token", valid_580710
  var valid_580711 = query.getOrDefault("callback")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "callback", valid_580711
  var valid_580712 = query.getOrDefault("access_token")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "access_token", valid_580712
  var valid_580713 = query.getOrDefault("uploadType")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "uploadType", valid_580713
  var valid_580714 = query.getOrDefault("orderBy")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "orderBy", valid_580714
  var valid_580715 = query.getOrDefault("key")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "key", valid_580715
  var valid_580716 = query.getOrDefault("$.xgafv")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = newJString("1"))
  if valid_580716 != nil:
    section.add "$.xgafv", valid_580716
  var valid_580717 = query.getOrDefault("pageSize")
  valid_580717 = validateParameter(valid_580717, JInt, required = false, default = nil)
  if valid_580717 != nil:
    section.add "pageSize", valid_580717
  var valid_580718 = query.getOrDefault("prettyPrint")
  valid_580718 = validateParameter(valid_580718, JBool, required = false,
                                 default = newJBool(true))
  if valid_580718 != nil:
    section.add "prettyPrint", valid_580718
  var valid_580719 = query.getOrDefault("filter")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "filter", valid_580719
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580720: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580701;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the messages in the given HL7v2 store with support for filtering.
  ## 
  ## Note: HL7v2 messages are indexed asynchronously, so there might be a slight
  ## delay between the time a message is created and when it can be found
  ## through a filter.
  ## 
  let valid = call_580720.validator(path, query, header, formData, body)
  let scheme = call_580720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580720.url(scheme.get, call_580720.host, call_580720.base,
                         call_580720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580720, url, valid)

proc call*(call_580721: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580701;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList
  ## Lists all the messages in the given HL7v2 store with support for filtering.
  ## 
  ## Note: HL7v2 messages are indexed asynchronously, so there might be a slight
  ## delay between the time a message is created and when it can be found
  ## through a filter.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from the previous List request, if any.
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
  ##         : Name of the HL7v2 store to retrieve messages from.
  ##   orderBy: string
  ##          : Orders messages returned by the specified order_by clause.
  ## Syntax: https://cloud.google.com/apis/design/design_patterns#sorting_order
  ## 
  ## Fields available for ordering are:
  ## 
  ## *  `send_time`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Limit on the number of messages to return in a single response.
  ## If zero the default page size of 100 is used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Restricts messages returned to those matching a filter. Syntax:
  ## https://cloud.google.com/appengine/docs/standard/python/search/query_strings
  ## 
  ## Fields/functions available for filtering are:
  ## 
  ## *  `message_type`, from the MSH-9 segment; for example
  ## `NOT message_type = "ADT"`
  ## *  `send_date` or `sendDate`, the YYYY-MM-DD date the message was sent in
  ## the dataset's time_zone, from the MSH-7 segment; for example
  ## `send_date < "2017-01-02"`
  ## *  `send_time`, the timestamp when the message was sent, using the
  ## RFC3339 time format for comparisons, from the MSH-7 segment; for example
  ## `send_time < "2017-01-02T00:00:00-05:00"`
  ## *  `send_facility`, the care center that the message came from, from the
  ## MSH-4 segment; for example `send_facility = "ABC"`
  ## *  `HL7RegExp(expr)`, which does regular expression matching of `expr`
  ## against the message payload using re2 (http://code.google.com/p/re2/)
  ## syntax; for example `HL7RegExp("^.*\|.*\|EMERG")`
  ## *  `PatientId(value, type)`, which matches if the message lists a patient
  ## having an ID of the given value and type in the PID-2, PID-3, or PID-4
  ## segments; for example `PatientId("123456", "MRN")`
  ## *  `labels.x`, a string value of the label with key `x` as set using the
  ## Message.labels
  ## map, for example `labels."priority"="high"`. The operator `:*` can be used
  ## to assert the existence of a label, for example `labels."priority":*`.
  ## 
  ## Limitations on conjunctions:
  ## 
  ## *  Negation on the patient ID function or the labels field is not
  ## supported, for example these queries are invalid:
  ## `NOT PatientId("123456", "MRN")`, `NOT labels."tag1":*`,
  ## `NOT labels."tag2"="val2"`.
  ## *  Conjunction of multiple patient ID functions is not supported, for
  ## example this query is invalid:
  ## `PatientId("123456", "MRN") AND PatientId("456789", "MRN")`.
  ## *  Conjunction of multiple labels fields is also not supported, for
  ## example this query is invalid: `labels."tag1":* AND labels."tag2"="val2"`.
  ## *  Conjunction of one patient ID function, one labels field and conditions
  ## on other fields is supported, for example this query is valid:
  ## `PatientId("123456", "MRN") AND labels."tag1":* AND message_type = "ADT"`.
  ## 
  ## The HasLabel(x) and Label(x) syntax from previous API versions are
  ## deprecated; replaced by the `labels.x` syntax.
  var path_580722 = newJObject()
  var query_580723 = newJObject()
  add(query_580723, "upload_protocol", newJString(uploadProtocol))
  add(query_580723, "fields", newJString(fields))
  add(query_580723, "pageToken", newJString(pageToken))
  add(query_580723, "quotaUser", newJString(quotaUser))
  add(query_580723, "alt", newJString(alt))
  add(query_580723, "oauth_token", newJString(oauthToken))
  add(query_580723, "callback", newJString(callback))
  add(query_580723, "access_token", newJString(accessToken))
  add(query_580723, "uploadType", newJString(uploadType))
  add(path_580722, "parent", newJString(parent))
  add(query_580723, "orderBy", newJString(orderBy))
  add(query_580723, "key", newJString(key))
  add(query_580723, "$.xgafv", newJString(Xgafv))
  add(query_580723, "pageSize", newJInt(pageSize))
  add(query_580723, "prettyPrint", newJBool(prettyPrint))
  add(query_580723, "filter", newJString(filter))
  result = call_580721.call(path_580722, query_580723, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580701(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580702,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580703,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580745 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580747(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/messages:ingest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580746(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Ingests a new HL7v2 message from the hospital and sends a notification to
  ## the Cloud Pub/Sub topic. Return is an HL7v2 ACK message if the message was
  ## successfully stored. Otherwise an error is returned.  If an identical
  ## HL7v2 message is created twice only one resource is created on the server
  ## and no error is reported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the HL7v2 store this message belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580748 = path.getOrDefault("parent")
  valid_580748 = validateParameter(valid_580748, JString, required = true,
                                 default = nil)
  if valid_580748 != nil:
    section.add "parent", valid_580748
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
  var valid_580749 = query.getOrDefault("upload_protocol")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "upload_protocol", valid_580749
  var valid_580750 = query.getOrDefault("fields")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = nil)
  if valid_580750 != nil:
    section.add "fields", valid_580750
  var valid_580751 = query.getOrDefault("quotaUser")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "quotaUser", valid_580751
  var valid_580752 = query.getOrDefault("alt")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = newJString("json"))
  if valid_580752 != nil:
    section.add "alt", valid_580752
  var valid_580753 = query.getOrDefault("oauth_token")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "oauth_token", valid_580753
  var valid_580754 = query.getOrDefault("callback")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "callback", valid_580754
  var valid_580755 = query.getOrDefault("access_token")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "access_token", valid_580755
  var valid_580756 = query.getOrDefault("uploadType")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "uploadType", valid_580756
  var valid_580757 = query.getOrDefault("key")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "key", valid_580757
  var valid_580758 = query.getOrDefault("$.xgafv")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = newJString("1"))
  if valid_580758 != nil:
    section.add "$.xgafv", valid_580758
  var valid_580759 = query.getOrDefault("prettyPrint")
  valid_580759 = validateParameter(valid_580759, JBool, required = false,
                                 default = newJBool(true))
  if valid_580759 != nil:
    section.add "prettyPrint", valid_580759
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

proc call*(call_580761: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580745;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Ingests a new HL7v2 message from the hospital and sends a notification to
  ## the Cloud Pub/Sub topic. Return is an HL7v2 ACK message if the message was
  ## successfully stored. Otherwise an error is returned.  If an identical
  ## HL7v2 message is created twice only one resource is created on the server
  ## and no error is reported.
  ## 
  let valid = call_580761.validator(path, query, header, formData, body)
  let scheme = call_580761.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580761.url(scheme.get, call_580761.host, call_580761.base,
                         call_580761.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580761, url, valid)

proc call*(call_580762: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580745;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest
  ## Ingests a new HL7v2 message from the hospital and sends a notification to
  ## the Cloud Pub/Sub topic. Return is an HL7v2 ACK message if the message was
  ## successfully stored. Otherwise an error is returned.  If an identical
  ## HL7v2 message is created twice only one resource is created on the server
  ## and no error is reported.
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
  ##         : The name of the HL7v2 store this message belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580763 = newJObject()
  var query_580764 = newJObject()
  var body_580765 = newJObject()
  add(query_580764, "upload_protocol", newJString(uploadProtocol))
  add(query_580764, "fields", newJString(fields))
  add(query_580764, "quotaUser", newJString(quotaUser))
  add(query_580764, "alt", newJString(alt))
  add(query_580764, "oauth_token", newJString(oauthToken))
  add(query_580764, "callback", newJString(callback))
  add(query_580764, "access_token", newJString(accessToken))
  add(query_580764, "uploadType", newJString(uploadType))
  add(path_580763, "parent", newJString(parent))
  add(query_580764, "key", newJString(key))
  add(query_580764, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580765 = body
  add(query_580764, "prettyPrint", newJBool(prettyPrint))
  result = call_580762.call(path_580763, query_580764, nil, nil, body_580765)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580745(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{parent}/messages:ingest", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580746,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580747,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_580786 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_580788(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_580787(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource. Returns NOT_FOUND error if
  ## the resource does not exist. Returns an empty policy if the resource exists
  ## but does not have a policy set.
  ## 
  ## Authorization requires the Google IAM permission
  ## `healthcare.AnnotationStores.getIamPolicy` on the specified
  ## resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580789 = path.getOrDefault("resource")
  valid_580789 = validateParameter(valid_580789, JString, required = true,
                                 default = nil)
  if valid_580789 != nil:
    section.add "resource", valid_580789
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
  var valid_580790 = query.getOrDefault("upload_protocol")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = nil)
  if valid_580790 != nil:
    section.add "upload_protocol", valid_580790
  var valid_580791 = query.getOrDefault("fields")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = nil)
  if valid_580791 != nil:
    section.add "fields", valid_580791
  var valid_580792 = query.getOrDefault("quotaUser")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "quotaUser", valid_580792
  var valid_580793 = query.getOrDefault("alt")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = newJString("json"))
  if valid_580793 != nil:
    section.add "alt", valid_580793
  var valid_580794 = query.getOrDefault("oauth_token")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "oauth_token", valid_580794
  var valid_580795 = query.getOrDefault("callback")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "callback", valid_580795
  var valid_580796 = query.getOrDefault("access_token")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "access_token", valid_580796
  var valid_580797 = query.getOrDefault("uploadType")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "uploadType", valid_580797
  var valid_580798 = query.getOrDefault("key")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = nil)
  if valid_580798 != nil:
    section.add "key", valid_580798
  var valid_580799 = query.getOrDefault("$.xgafv")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = newJString("1"))
  if valid_580799 != nil:
    section.add "$.xgafv", valid_580799
  var valid_580800 = query.getOrDefault("prettyPrint")
  valid_580800 = validateParameter(valid_580800, JBool, required = false,
                                 default = newJBool(true))
  if valid_580800 != nil:
    section.add "prettyPrint", valid_580800
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

proc call*(call_580802: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_580786;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. Returns NOT_FOUND error if
  ## the resource does not exist. Returns an empty policy if the resource exists
  ## but does not have a policy set.
  ## 
  ## Authorization requires the Google IAM permission
  ## `healthcare.AnnotationStores.getIamPolicy` on the specified
  ## resource
  ## 
  let valid = call_580802.validator(path, query, header, formData, body)
  let scheme = call_580802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580802.url(scheme.get, call_580802.host, call_580802.base,
                         call_580802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580802, url, valid)

proc call*(call_580803: Call_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_580786;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy
  ## Gets the access control policy for a resource. Returns NOT_FOUND error if
  ## the resource does not exist. Returns an empty policy if the resource exists
  ## but does not have a policy set.
  ## 
  ## Authorization requires the Google IAM permission
  ## `healthcare.AnnotationStores.getIamPolicy` on the specified
  ## resource
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580804 = newJObject()
  var query_580805 = newJObject()
  var body_580806 = newJObject()
  add(query_580805, "upload_protocol", newJString(uploadProtocol))
  add(query_580805, "fields", newJString(fields))
  add(query_580805, "quotaUser", newJString(quotaUser))
  add(query_580805, "alt", newJString(alt))
  add(query_580805, "oauth_token", newJString(oauthToken))
  add(query_580805, "callback", newJString(callback))
  add(query_580805, "access_token", newJString(accessToken))
  add(query_580805, "uploadType", newJString(uploadType))
  add(query_580805, "key", newJString(key))
  add(query_580805, "$.xgafv", newJString(Xgafv))
  add(path_580804, "resource", newJString(resource))
  if body != nil:
    body_580806 = body
  add(query_580805, "prettyPrint", newJBool(prettyPrint))
  result = call_580803.call(path_580804, query_580805, nil, nil, body_580806)

var healthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_580786(
    name: "healthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{resource}:getIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_580787,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsAnnotationStoresGetIamPolicy_580788,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_580766 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_580768(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_580767(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580769 = path.getOrDefault("resource")
  valid_580769 = validateParameter(valid_580769, JString, required = true,
                                 default = nil)
  if valid_580769 != nil:
    section.add "resource", valid_580769
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580770 = query.getOrDefault("upload_protocol")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "upload_protocol", valid_580770
  var valid_580771 = query.getOrDefault("fields")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "fields", valid_580771
  var valid_580772 = query.getOrDefault("quotaUser")
  valid_580772 = validateParameter(valid_580772, JString, required = false,
                                 default = nil)
  if valid_580772 != nil:
    section.add "quotaUser", valid_580772
  var valid_580773 = query.getOrDefault("alt")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = newJString("json"))
  if valid_580773 != nil:
    section.add "alt", valid_580773
  var valid_580774 = query.getOrDefault("oauth_token")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "oauth_token", valid_580774
  var valid_580775 = query.getOrDefault("callback")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "callback", valid_580775
  var valid_580776 = query.getOrDefault("access_token")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "access_token", valid_580776
  var valid_580777 = query.getOrDefault("uploadType")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "uploadType", valid_580777
  var valid_580778 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580778 = validateParameter(valid_580778, JInt, required = false, default = nil)
  if valid_580778 != nil:
    section.add "options.requestedPolicyVersion", valid_580778
  var valid_580779 = query.getOrDefault("key")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "key", valid_580779
  var valid_580780 = query.getOrDefault("$.xgafv")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = newJString("1"))
  if valid_580780 != nil:
    section.add "$.xgafv", valid_580780
  var valid_580781 = query.getOrDefault("prettyPrint")
  valid_580781 = validateParameter(valid_580781, JBool, required = false,
                                 default = newJBool(true))
  if valid_580781 != nil:
    section.add "prettyPrint", valid_580781
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580782: Call_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_580766;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580782.validator(path, query, header, formData, body)
  let scheme = call_580782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580782.url(scheme.get, call_580782.host, call_580782.base,
                         call_580782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580782, url, valid)

proc call*(call_580783: Call_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_580766;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580784 = newJObject()
  var query_580785 = newJObject()
  add(query_580785, "upload_protocol", newJString(uploadProtocol))
  add(query_580785, "fields", newJString(fields))
  add(query_580785, "quotaUser", newJString(quotaUser))
  add(query_580785, "alt", newJString(alt))
  add(query_580785, "oauth_token", newJString(oauthToken))
  add(query_580785, "callback", newJString(callback))
  add(query_580785, "access_token", newJString(accessToken))
  add(query_580785, "uploadType", newJString(uploadType))
  add(query_580785, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580785, "key", newJString(key))
  add(query_580785, "$.xgafv", newJString(Xgafv))
  add(path_580784, "resource", newJString(resource))
  add(query_580785, "prettyPrint", newJBool(prettyPrint))
  result = call_580783.call(path_580784, query_580785, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_580766(
    name: "healthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{resource}:getIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_580767,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsDicomStoresGetIamPolicy_580768,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_580807 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_580809(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_580808(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580810 = path.getOrDefault("resource")
  valid_580810 = validateParameter(valid_580810, JString, required = true,
                                 default = nil)
  if valid_580810 != nil:
    section.add "resource", valid_580810
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
  var valid_580811 = query.getOrDefault("upload_protocol")
  valid_580811 = validateParameter(valid_580811, JString, required = false,
                                 default = nil)
  if valid_580811 != nil:
    section.add "upload_protocol", valid_580811
  var valid_580812 = query.getOrDefault("fields")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = nil)
  if valid_580812 != nil:
    section.add "fields", valid_580812
  var valid_580813 = query.getOrDefault("quotaUser")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = nil)
  if valid_580813 != nil:
    section.add "quotaUser", valid_580813
  var valid_580814 = query.getOrDefault("alt")
  valid_580814 = validateParameter(valid_580814, JString, required = false,
                                 default = newJString("json"))
  if valid_580814 != nil:
    section.add "alt", valid_580814
  var valid_580815 = query.getOrDefault("oauth_token")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "oauth_token", valid_580815
  var valid_580816 = query.getOrDefault("callback")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "callback", valid_580816
  var valid_580817 = query.getOrDefault("access_token")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = nil)
  if valid_580817 != nil:
    section.add "access_token", valid_580817
  var valid_580818 = query.getOrDefault("uploadType")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = nil)
  if valid_580818 != nil:
    section.add "uploadType", valid_580818
  var valid_580819 = query.getOrDefault("key")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "key", valid_580819
  var valid_580820 = query.getOrDefault("$.xgafv")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = newJString("1"))
  if valid_580820 != nil:
    section.add "$.xgafv", valid_580820
  var valid_580821 = query.getOrDefault("prettyPrint")
  valid_580821 = validateParameter(valid_580821, JBool, required = false,
                                 default = newJBool(true))
  if valid_580821 != nil:
    section.add "prettyPrint", valid_580821
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

proc call*(call_580823: Call_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_580807;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580823.validator(path, query, header, formData, body)
  let scheme = call_580823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580823.url(scheme.get, call_580823.host, call_580823.base,
                         call_580823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580823, url, valid)

proc call*(call_580824: Call_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_580807;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580825 = newJObject()
  var query_580826 = newJObject()
  var body_580827 = newJObject()
  add(query_580826, "upload_protocol", newJString(uploadProtocol))
  add(query_580826, "fields", newJString(fields))
  add(query_580826, "quotaUser", newJString(quotaUser))
  add(query_580826, "alt", newJString(alt))
  add(query_580826, "oauth_token", newJString(oauthToken))
  add(query_580826, "callback", newJString(callback))
  add(query_580826, "access_token", newJString(accessToken))
  add(query_580826, "uploadType", newJString(uploadType))
  add(query_580826, "key", newJString(key))
  add(query_580826, "$.xgafv", newJString(Xgafv))
  add(path_580825, "resource", newJString(resource))
  if body != nil:
    body_580827 = body
  add(query_580826, "prettyPrint", newJBool(prettyPrint))
  result = call_580824.call(path_580825, query_580826, nil, nil, body_580827)

var healthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_580807(
    name: "healthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{resource}:setIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_580808,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsDicomStoresSetIamPolicy_580809,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_580828 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_580830(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_580829(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580831 = path.getOrDefault("resource")
  valid_580831 = validateParameter(valid_580831, JString, required = true,
                                 default = nil)
  if valid_580831 != nil:
    section.add "resource", valid_580831
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
  var valid_580832 = query.getOrDefault("upload_protocol")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "upload_protocol", valid_580832
  var valid_580833 = query.getOrDefault("fields")
  valid_580833 = validateParameter(valid_580833, JString, required = false,
                                 default = nil)
  if valid_580833 != nil:
    section.add "fields", valid_580833
  var valid_580834 = query.getOrDefault("quotaUser")
  valid_580834 = validateParameter(valid_580834, JString, required = false,
                                 default = nil)
  if valid_580834 != nil:
    section.add "quotaUser", valid_580834
  var valid_580835 = query.getOrDefault("alt")
  valid_580835 = validateParameter(valid_580835, JString, required = false,
                                 default = newJString("json"))
  if valid_580835 != nil:
    section.add "alt", valid_580835
  var valid_580836 = query.getOrDefault("oauth_token")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "oauth_token", valid_580836
  var valid_580837 = query.getOrDefault("callback")
  valid_580837 = validateParameter(valid_580837, JString, required = false,
                                 default = nil)
  if valid_580837 != nil:
    section.add "callback", valid_580837
  var valid_580838 = query.getOrDefault("access_token")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = nil)
  if valid_580838 != nil:
    section.add "access_token", valid_580838
  var valid_580839 = query.getOrDefault("uploadType")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "uploadType", valid_580839
  var valid_580840 = query.getOrDefault("key")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = nil)
  if valid_580840 != nil:
    section.add "key", valid_580840
  var valid_580841 = query.getOrDefault("$.xgafv")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = newJString("1"))
  if valid_580841 != nil:
    section.add "$.xgafv", valid_580841
  var valid_580842 = query.getOrDefault("prettyPrint")
  valid_580842 = validateParameter(valid_580842, JBool, required = false,
                                 default = newJBool(true))
  if valid_580842 != nil:
    section.add "prettyPrint", valid_580842
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

proc call*(call_580844: Call_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_580828;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  let valid = call_580844.validator(path, query, header, formData, body)
  let scheme = call_580844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580844.url(scheme.get, call_580844.host, call_580844.base,
                         call_580844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580844, url, valid)

proc call*(call_580845: Call_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_580828;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580846 = newJObject()
  var query_580847 = newJObject()
  var body_580848 = newJObject()
  add(query_580847, "upload_protocol", newJString(uploadProtocol))
  add(query_580847, "fields", newJString(fields))
  add(query_580847, "quotaUser", newJString(quotaUser))
  add(query_580847, "alt", newJString(alt))
  add(query_580847, "oauth_token", newJString(oauthToken))
  add(query_580847, "callback", newJString(callback))
  add(query_580847, "access_token", newJString(accessToken))
  add(query_580847, "uploadType", newJString(uploadType))
  add(query_580847, "key", newJString(key))
  add(query_580847, "$.xgafv", newJString(Xgafv))
  add(path_580846, "resource", newJString(resource))
  if body != nil:
    body_580848 = body
  add(query_580847, "prettyPrint", newJBool(prettyPrint))
  result = call_580845.call(path_580846, query_580847, nil, nil, body_580848)

var healthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions* = Call_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_580828(
    name: "healthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{resource}:testIamPermissions", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_580829,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsDicomStoresTestIamPermissions_580830,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDeidentify_580849 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDeidentify_580851(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceDataset" in path, "`sourceDataset` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "sourceDataset"),
               (kind: ConstantSegment, value: ":deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDeidentify_580850(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new dataset containing de-identified data from the source
  ## dataset. The metadata field type
  ## is OperationMetadata.
  ## If the request is successful, the
  ## response field type is
  ## DeidentifySummary.
  ## If errors occur,
  ## details field type is
  ## DeidentifyErrorDetails.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceDataset: JString (required)
  ##                : Source dataset resource name. (e.g.,
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}`).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sourceDataset` field"
  var valid_580852 = path.getOrDefault("sourceDataset")
  valid_580852 = validateParameter(valid_580852, JString, required = true,
                                 default = nil)
  if valid_580852 != nil:
    section.add "sourceDataset", valid_580852
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
  var valid_580853 = query.getOrDefault("upload_protocol")
  valid_580853 = validateParameter(valid_580853, JString, required = false,
                                 default = nil)
  if valid_580853 != nil:
    section.add "upload_protocol", valid_580853
  var valid_580854 = query.getOrDefault("fields")
  valid_580854 = validateParameter(valid_580854, JString, required = false,
                                 default = nil)
  if valid_580854 != nil:
    section.add "fields", valid_580854
  var valid_580855 = query.getOrDefault("quotaUser")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = nil)
  if valid_580855 != nil:
    section.add "quotaUser", valid_580855
  var valid_580856 = query.getOrDefault("alt")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = newJString("json"))
  if valid_580856 != nil:
    section.add "alt", valid_580856
  var valid_580857 = query.getOrDefault("oauth_token")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "oauth_token", valid_580857
  var valid_580858 = query.getOrDefault("callback")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = nil)
  if valid_580858 != nil:
    section.add "callback", valid_580858
  var valid_580859 = query.getOrDefault("access_token")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "access_token", valid_580859
  var valid_580860 = query.getOrDefault("uploadType")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = nil)
  if valid_580860 != nil:
    section.add "uploadType", valid_580860
  var valid_580861 = query.getOrDefault("key")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "key", valid_580861
  var valid_580862 = query.getOrDefault("$.xgafv")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = newJString("1"))
  if valid_580862 != nil:
    section.add "$.xgafv", valid_580862
  var valid_580863 = query.getOrDefault("prettyPrint")
  valid_580863 = validateParameter(valid_580863, JBool, required = false,
                                 default = newJBool(true))
  if valid_580863 != nil:
    section.add "prettyPrint", valid_580863
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

proc call*(call_580865: Call_HealthcareProjectsLocationsDatasetsDeidentify_580849;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new dataset containing de-identified data from the source
  ## dataset. The metadata field type
  ## is OperationMetadata.
  ## If the request is successful, the
  ## response field type is
  ## DeidentifySummary.
  ## If errors occur,
  ## details field type is
  ## DeidentifyErrorDetails.
  ## 
  let valid = call_580865.validator(path, query, header, formData, body)
  let scheme = call_580865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580865.url(scheme.get, call_580865.host, call_580865.base,
                         call_580865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580865, url, valid)

proc call*(call_580866: Call_HealthcareProjectsLocationsDatasetsDeidentify_580849;
          sourceDataset: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDeidentify
  ## Creates a new dataset containing de-identified data from the source
  ## dataset. The metadata field type
  ## is OperationMetadata.
  ## If the request is successful, the
  ## response field type is
  ## DeidentifySummary.
  ## If errors occur,
  ## details field type is
  ## DeidentifyErrorDetails.
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
  ##   sourceDataset: string (required)
  ##                : Source dataset resource name. (e.g.,
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}`).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580867 = newJObject()
  var query_580868 = newJObject()
  var body_580869 = newJObject()
  add(query_580868, "upload_protocol", newJString(uploadProtocol))
  add(query_580868, "fields", newJString(fields))
  add(query_580868, "quotaUser", newJString(quotaUser))
  add(query_580868, "alt", newJString(alt))
  add(query_580868, "oauth_token", newJString(oauthToken))
  add(query_580868, "callback", newJString(callback))
  add(query_580868, "access_token", newJString(accessToken))
  add(query_580868, "uploadType", newJString(uploadType))
  add(query_580868, "key", newJString(key))
  add(query_580868, "$.xgafv", newJString(Xgafv))
  add(path_580867, "sourceDataset", newJString(sourceDataset))
  if body != nil:
    body_580869 = body
  add(query_580868, "prettyPrint", newJBool(prettyPrint))
  result = call_580866.call(path_580867, query_580868, nil, nil, body_580869)

var healthcareProjectsLocationsDatasetsDeidentify* = Call_HealthcareProjectsLocationsDatasetsDeidentify_580849(
    name: "healthcareProjectsLocationsDatasetsDeidentify",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1alpha2/{sourceDataset}:deidentify",
    validator: validate_HealthcareProjectsLocationsDatasetsDeidentify_580850,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDeidentify_580851,
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
