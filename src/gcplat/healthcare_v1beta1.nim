
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Healthcare
## version: v1beta1
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{name}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579980,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_579981,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_579690 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_579692(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_579691(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the contents of a FHIR resource.
  ## 
  ## Implements the FHIR standard [read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#read).
  ## 
  ## Also supports the FHIR standard [conditional read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cread)
  ## specified by supplying an `If-Modified-Since` header with a date/time value
  ## or an `If-None-Match` header with an ETag value.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource.
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
  ##       : Specifies which parts of the Message resource to return in the response.
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

proc call*(call_579866: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the contents of a FHIR resource.
  ## 
  ## Implements the FHIR standard [read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#read).
  ## 
  ## Also supports the FHIR standard [conditional read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cread)
  ## specified by supplying an `If-Modified-Since` header with a date/time value
  ## or an `If-None-Match` header with an ETag value.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ## 
  let valid = call_579866.validator(path, query, header, formData, body)
  let scheme = call_579866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579866.url(scheme.get, call_579866.host, call_579866.base,
                         call_579866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579866, url, valid)

proc call*(call_579937: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_579690;
          name: string; uploadProtocol: string = ""; fields: string = "";
          view: string = "MESSAGE_VIEW_UNSPECIFIED"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirRead
  ## Gets the contents of a FHIR resource.
  ## 
  ## Implements the FHIR standard [read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#read).
  ## 
  ## Also supports the FHIR standard [conditional read
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#cread)
  ## specified by supplying an `If-Modified-Since` header with a date/time value
  ## or an `If-None-Match` header with an ETag value.
  ## 
  ## On success, the response body will contain a JSON-encoded representation
  ## of the resource.
  ## Errors generated by the FHIR store will contain a JSON-encoded
  ## `OperationOutcome` resource describing the reason for the error. If the
  ## request cannot be mapped to a valid API method on a FHIR store, a generic
  ## GCP error might be returned instead.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Specifies which parts of the Message resource to return in the response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to retrieve.
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

var healthcareProjectsLocationsDatasetsFhirStoresFhirRead* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_579690(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirRead",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_579691,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_579692,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_580019 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_580021(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_580020(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates part of an existing resource by applying the operations specified
  ## in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
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
  ##   name: JString (required)
  ##       : The name of the resource to update.
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

proc call*(call_580036: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_580019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates part of an existing resource by applying the operations specified
  ## in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
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
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_580019;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirPatch
  ## Updates part of an existing resource by applying the operations specified
  ## in a [JSON Patch](http://jsonpatch.com/) document.
  ## 
  ## Implements the FHIR standard [patch
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#patch).
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

var healthcareProjectsLocationsDatasetsFhirStoresFhirPatch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_580019(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_580020,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_580021,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_580000 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_580002(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_580001(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a FHIR resource.
  ## 
  ## Implements the FHIR standard [delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#delete).
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
  ##   name: JString (required)
  ##       : The name of the resource to delete.
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

proc call*(call_580015: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_580000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a FHIR resource.
  ## 
  ## Implements the FHIR standard [delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#delete).
  ## 
  ## Note: Unless resource versioning is disabled by setting the
  ## disable_resource_versioning flag
  ## on the FHIR store, the deleted resources will be moved to a history
  ## repository that can still be retrieved through vread
  ## and related methods, unless they are removed by the
  ## purge method.
  ## 
  let valid = call_580015.validator(path, query, header, formData, body)
  let scheme = call_580015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580015.url(scheme.get, call_580015.host, call_580015.base,
                         call_580015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580015, url, valid)

proc call*(call_580016: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_580000;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresFhirDelete
  ## Deletes a FHIR resource.
  ## 
  ## Implements the FHIR standard [delete
  ## interaction](http://hl7.org/implement/standards/fhir/STU3/http.html#delete).
  ## 
  ## Note: Unless resource versioning is disabled by setting the
  ## disable_resource_versioning flag
  ## on the FHIR store, the deleted resources will be moved to a history
  ## repository that can still be retrieved through vread
  ## and related methods, unless they are removed by the
  ## purge method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the resource to delete.
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

var healthcareProjectsLocationsDatasetsFhirStoresFhirDelete* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_580000(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_580001,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_580002,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
  ## in next or previous page links' urls. Next and previous page are returned
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
  ## in next or previous page links' urls. Next and previous page are returned
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
    route: "/v1beta1/{name}/$everything", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_580042,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{name}/$purge", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_580065,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{name}/_history", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_580084,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{name}/fhir/metadata", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_580107,
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    host: "healthcare.googleapis.com", route: "/v1beta1/{name}/locations",
    validator: validate_HealthcareProjectsLocationsList_580126, base: "/",
    url: url_HealthcareProjectsLocationsList_580127, schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsOperationsList_580147 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsOperationsList_580149(
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
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsOperationsList_580148(
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
  var valid_580153 = query.getOrDefault("pageToken")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "pageToken", valid_580153
  var valid_580154 = query.getOrDefault("quotaUser")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "quotaUser", valid_580154
  var valid_580155 = query.getOrDefault("alt")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("json"))
  if valid_580155 != nil:
    section.add "alt", valid_580155
  var valid_580156 = query.getOrDefault("oauth_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "oauth_token", valid_580156
  var valid_580157 = query.getOrDefault("callback")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "callback", valid_580157
  var valid_580158 = query.getOrDefault("access_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "access_token", valid_580158
  var valid_580159 = query.getOrDefault("uploadType")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "uploadType", valid_580159
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("$.xgafv")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("1"))
  if valid_580161 != nil:
    section.add "$.xgafv", valid_580161
  var valid_580162 = query.getOrDefault("pageSize")
  valid_580162 = validateParameter(valid_580162, JInt, required = false, default = nil)
  if valid_580162 != nil:
    section.add "pageSize", valid_580162
  var valid_580163 = query.getOrDefault("prettyPrint")
  valid_580163 = validateParameter(valid_580163, JBool, required = false,
                                 default = newJBool(true))
  if valid_580163 != nil:
    section.add "prettyPrint", valid_580163
  var valid_580164 = query.getOrDefault("filter")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "filter", valid_580164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580165: Call_HealthcareProjectsLocationsDatasetsOperationsList_580147;
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
  let valid = call_580165.validator(path, query, header, formData, body)
  let scheme = call_580165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580165.url(scheme.get, call_580165.host, call_580165.base,
                         call_580165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580165, url, valid)

proc call*(call_580166: Call_HealthcareProjectsLocationsDatasetsOperationsList_580147;
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
  var path_580167 = newJObject()
  var query_580168 = newJObject()
  add(query_580168, "upload_protocol", newJString(uploadProtocol))
  add(query_580168, "fields", newJString(fields))
  add(query_580168, "pageToken", newJString(pageToken))
  add(query_580168, "quotaUser", newJString(quotaUser))
  add(path_580167, "name", newJString(name))
  add(query_580168, "alt", newJString(alt))
  add(query_580168, "oauth_token", newJString(oauthToken))
  add(query_580168, "callback", newJString(callback))
  add(query_580168, "access_token", newJString(accessToken))
  add(query_580168, "uploadType", newJString(uploadType))
  add(query_580168, "key", newJString(key))
  add(query_580168, "$.xgafv", newJString(Xgafv))
  add(query_580168, "pageSize", newJInt(pageSize))
  add(query_580168, "prettyPrint", newJBool(prettyPrint))
  add(query_580168, "filter", newJString(filter))
  result = call_580166.call(path_580167, query_580168, nil, nil, nil)

var healthcareProjectsLocationsDatasetsOperationsList* = Call_HealthcareProjectsLocationsDatasetsOperationsList_580147(
    name: "healthcareProjectsLocationsDatasetsOperationsList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}/operations",
    validator: validate_HealthcareProjectsLocationsDatasetsOperationsList_580148,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsOperationsList_580149,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_580169 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresExport_580171(
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
               (kind: ConstantSegment, value: ":export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresExport_580170(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Export resources from the FHIR store to the specified destination.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the export by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## Otherwise, when the operation finishes, a detailed response of type
  ## ExportResourcesResponse is returned in the
  ## response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the FHIR store to export resource from. The name should be in
  ## the format of
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/fhirStores/{fhir_store_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580172 = path.getOrDefault("name")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = nil)
  if valid_580172 != nil:
    section.add "name", valid_580172
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
  var valid_580173 = query.getOrDefault("upload_protocol")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "upload_protocol", valid_580173
  var valid_580174 = query.getOrDefault("fields")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "fields", valid_580174
  var valid_580175 = query.getOrDefault("quotaUser")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "quotaUser", valid_580175
  var valid_580176 = query.getOrDefault("alt")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("json"))
  if valid_580176 != nil:
    section.add "alt", valid_580176
  var valid_580177 = query.getOrDefault("oauth_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "oauth_token", valid_580177
  var valid_580178 = query.getOrDefault("callback")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "callback", valid_580178
  var valid_580179 = query.getOrDefault("access_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "access_token", valid_580179
  var valid_580180 = query.getOrDefault("uploadType")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "uploadType", valid_580180
  var valid_580181 = query.getOrDefault("key")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "key", valid_580181
  var valid_580182 = query.getOrDefault("$.xgafv")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("1"))
  if valid_580182 != nil:
    section.add "$.xgafv", valid_580182
  var valid_580183 = query.getOrDefault("prettyPrint")
  valid_580183 = validateParameter(valid_580183, JBool, required = false,
                                 default = newJBool(true))
  if valid_580183 != nil:
    section.add "prettyPrint", valid_580183
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

proc call*(call_580185: Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_580169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export resources from the FHIR store to the specified destination.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the export by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## Otherwise, when the operation finishes, a detailed response of type
  ## ExportResourcesResponse is returned in the
  ## response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ## 
  let valid = call_580185.validator(path, query, header, formData, body)
  let scheme = call_580185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580185.url(scheme.get, call_580185.host, call_580185.base,
                         call_580185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580185, url, valid)

proc call*(call_580186: Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_580169;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresExport
  ## Export resources from the FHIR store to the specified destination.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the export by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)).
  ## Otherwise, when the operation finishes, a detailed response of type
  ## ExportResourcesResponse is returned in the
  ## response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the FHIR store to export resource from. The name should be in
  ## the format of
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/fhirStores/{fhir_store_id}`.
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
  var path_580187 = newJObject()
  var query_580188 = newJObject()
  var body_580189 = newJObject()
  add(query_580188, "upload_protocol", newJString(uploadProtocol))
  add(query_580188, "fields", newJString(fields))
  add(query_580188, "quotaUser", newJString(quotaUser))
  add(path_580187, "name", newJString(name))
  add(query_580188, "alt", newJString(alt))
  add(query_580188, "oauth_token", newJString(oauthToken))
  add(query_580188, "callback", newJString(callback))
  add(query_580188, "access_token", newJString(accessToken))
  add(query_580188, "uploadType", newJString(uploadType))
  add(query_580188, "key", newJString(key))
  add(query_580188, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580189 = body
  add(query_580188, "prettyPrint", newJBool(prettyPrint))
  result = call_580186.call(path_580187, query_580188, nil, nil, body_580189)

var healthcareProjectsLocationsDatasetsFhirStoresExport* = Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_580169(
    name: "healthcareProjectsLocationsDatasetsFhirStoresExport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}:export",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresExport_580170,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresExport_580171,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_580190 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresImport_580192(
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
               (kind: ConstantSegment, value: ":import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresImport_580191(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Import resources to the FHIR store by loading data from the specified
  ## sources. This method is optimized to load large quantities of data using
  ## import semantics that ignore some FHIR store configuration options and are
  ## not suitable for all use cases. It is primarily intended to load data into
  ## an empty FHIR store that is not being used by other clients. In cases
  ## where this method is not appropriate, consider using ExecuteBundle to
  ## load data.
  ## 
  ## Every resource in the input must contain a client-supplied ID, and will be
  ## stored using that ID regardless of the
  ## enable_update_create setting on the FHIR
  ## store.
  ## 
  ## The import process does not enforce referential integrity, regardless of
  ## the
  ## disable_referential_integrity
  ## setting on the FHIR store. This allows the import of resources with
  ## arbitrary interdependencies without considering grouping or ordering, but
  ## if the input data contains invalid references or if some resources fail to
  ## be imported, the FHIR store might be left in a state that violates
  ## referential integrity.
  ## 
  ## If a resource with the specified ID already exists, the most recent
  ## version of the resource is overwritten without creating a new historical
  ## version, regardless of the
  ## disable_resource_versioning
  ## setting on the FHIR store. If transient failures occur during the import,
  ## it is possible that successfully imported resources will be overwritten
  ## more than once.
  ## 
  ## The import operation is idempotent unless the input data contains multiple
  ## valid resources with the same ID but different contents. In that case,
  ## after the import completes, the store will contain exactly one resource
  ## with that ID but there is no ordering guarantee on which version of the
  ## contents it will have. The operation result counters do not count
  ## duplicate IDs as an error and will count one success for each resource in
  ## the input, which might result in a success count larger than the number
  ## of resources in the FHIR store. This often occurs when importing data
  ## organized in bundles produced by Patient-everything
  ## where each bundle contains its own copy of a resource such as Practitioner
  ## that might be referred to by many patients.
  ## 
  ## If some resources fail to import, for example due to parsing errors,
  ## successfully imported resources are not rolled back.
  ## 
  ## The location and format of the input data is specified by the parameters
  ## below. Note that if no format is specified, this method assumes the
  ## `BUNDLE` format. When using the `BUNDLE` format this method ignores the
  ## `Bundle.type` field, except that `history` bundles are rejected, and does
  ## not apply any of the bundle processing semantics for batch or transaction
  ## bundles. Unlike in ExecuteBundle, transaction bundles are not executed
  ## as a single transaction and bundle-internal references are not rewritten.
  ## The bundle is treated as a collection of resources to be written as
  ## provided in `Bundle.entry.resource`, ignoring `Bundle.entry.request`. As
  ## an example, this allows the import of `searchset` bundles produced by a
  ## FHIR search or
  ## Patient-everything operation.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the import by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)). Otherwise, when the
  ## operation finishes, a detailed response of type ImportResourcesResponse
  ## is returned in the response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the FHIR store to import FHIR resources to. The name should be
  ## in the format of
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/fhirStores/{fhir_store_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580193 = path.getOrDefault("name")
  valid_580193 = validateParameter(valid_580193, JString, required = true,
                                 default = nil)
  if valid_580193 != nil:
    section.add "name", valid_580193
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
  var valid_580194 = query.getOrDefault("upload_protocol")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "upload_protocol", valid_580194
  var valid_580195 = query.getOrDefault("fields")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "fields", valid_580195
  var valid_580196 = query.getOrDefault("quotaUser")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "quotaUser", valid_580196
  var valid_580197 = query.getOrDefault("alt")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = newJString("json"))
  if valid_580197 != nil:
    section.add "alt", valid_580197
  var valid_580198 = query.getOrDefault("oauth_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "oauth_token", valid_580198
  var valid_580199 = query.getOrDefault("callback")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "callback", valid_580199
  var valid_580200 = query.getOrDefault("access_token")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "access_token", valid_580200
  var valid_580201 = query.getOrDefault("uploadType")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "uploadType", valid_580201
  var valid_580202 = query.getOrDefault("key")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "key", valid_580202
  var valid_580203 = query.getOrDefault("$.xgafv")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("1"))
  if valid_580203 != nil:
    section.add "$.xgafv", valid_580203
  var valid_580204 = query.getOrDefault("prettyPrint")
  valid_580204 = validateParameter(valid_580204, JBool, required = false,
                                 default = newJBool(true))
  if valid_580204 != nil:
    section.add "prettyPrint", valid_580204
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

proc call*(call_580206: Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_580190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Import resources to the FHIR store by loading data from the specified
  ## sources. This method is optimized to load large quantities of data using
  ## import semantics that ignore some FHIR store configuration options and are
  ## not suitable for all use cases. It is primarily intended to load data into
  ## an empty FHIR store that is not being used by other clients. In cases
  ## where this method is not appropriate, consider using ExecuteBundle to
  ## load data.
  ## 
  ## Every resource in the input must contain a client-supplied ID, and will be
  ## stored using that ID regardless of the
  ## enable_update_create setting on the FHIR
  ## store.
  ## 
  ## The import process does not enforce referential integrity, regardless of
  ## the
  ## disable_referential_integrity
  ## setting on the FHIR store. This allows the import of resources with
  ## arbitrary interdependencies without considering grouping or ordering, but
  ## if the input data contains invalid references or if some resources fail to
  ## be imported, the FHIR store might be left in a state that violates
  ## referential integrity.
  ## 
  ## If a resource with the specified ID already exists, the most recent
  ## version of the resource is overwritten without creating a new historical
  ## version, regardless of the
  ## disable_resource_versioning
  ## setting on the FHIR store. If transient failures occur during the import,
  ## it is possible that successfully imported resources will be overwritten
  ## more than once.
  ## 
  ## The import operation is idempotent unless the input data contains multiple
  ## valid resources with the same ID but different contents. In that case,
  ## after the import completes, the store will contain exactly one resource
  ## with that ID but there is no ordering guarantee on which version of the
  ## contents it will have. The operation result counters do not count
  ## duplicate IDs as an error and will count one success for each resource in
  ## the input, which might result in a success count larger than the number
  ## of resources in the FHIR store. This often occurs when importing data
  ## organized in bundles produced by Patient-everything
  ## where each bundle contains its own copy of a resource such as Practitioner
  ## that might be referred to by many patients.
  ## 
  ## If some resources fail to import, for example due to parsing errors,
  ## successfully imported resources are not rolled back.
  ## 
  ## The location and format of the input data is specified by the parameters
  ## below. Note that if no format is specified, this method assumes the
  ## `BUNDLE` format. When using the `BUNDLE` format this method ignores the
  ## `Bundle.type` field, except that `history` bundles are rejected, and does
  ## not apply any of the bundle processing semantics for batch or transaction
  ## bundles. Unlike in ExecuteBundle, transaction bundles are not executed
  ## as a single transaction and bundle-internal references are not rewritten.
  ## The bundle is treated as a collection of resources to be written as
  ## provided in `Bundle.entry.resource`, ignoring `Bundle.entry.request`. As
  ## an example, this allows the import of `searchset` bundles produced by a
  ## FHIR search or
  ## Patient-everything operation.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the import by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)). Otherwise, when the
  ## operation finishes, a detailed response of type ImportResourcesResponse
  ## is returned in the response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ## 
  let valid = call_580206.validator(path, query, header, formData, body)
  let scheme = call_580206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580206.url(scheme.get, call_580206.host, call_580206.base,
                         call_580206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580206, url, valid)

proc call*(call_580207: Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_580190;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresImport
  ## Import resources to the FHIR store by loading data from the specified
  ## sources. This method is optimized to load large quantities of data using
  ## import semantics that ignore some FHIR store configuration options and are
  ## not suitable for all use cases. It is primarily intended to load data into
  ## an empty FHIR store that is not being used by other clients. In cases
  ## where this method is not appropriate, consider using ExecuteBundle to
  ## load data.
  ## 
  ## Every resource in the input must contain a client-supplied ID, and will be
  ## stored using that ID regardless of the
  ## enable_update_create setting on the FHIR
  ## store.
  ## 
  ## The import process does not enforce referential integrity, regardless of
  ## the
  ## disable_referential_integrity
  ## setting on the FHIR store. This allows the import of resources with
  ## arbitrary interdependencies without considering grouping or ordering, but
  ## if the input data contains invalid references or if some resources fail to
  ## be imported, the FHIR store might be left in a state that violates
  ## referential integrity.
  ## 
  ## If a resource with the specified ID already exists, the most recent
  ## version of the resource is overwritten without creating a new historical
  ## version, regardless of the
  ## disable_resource_versioning
  ## setting on the FHIR store. If transient failures occur during the import,
  ## it is possible that successfully imported resources will be overwritten
  ## more than once.
  ## 
  ## The import operation is idempotent unless the input data contains multiple
  ## valid resources with the same ID but different contents. In that case,
  ## after the import completes, the store will contain exactly one resource
  ## with that ID but there is no ordering guarantee on which version of the
  ## contents it will have. The operation result counters do not count
  ## duplicate IDs as an error and will count one success for each resource in
  ## the input, which might result in a success count larger than the number
  ## of resources in the FHIR store. This often occurs when importing data
  ## organized in bundles produced by Patient-everything
  ## where each bundle contains its own copy of a resource such as Practitioner
  ## that might be referred to by many patients.
  ## 
  ## If some resources fail to import, for example due to parsing errors,
  ## successfully imported resources are not rolled back.
  ## 
  ## The location and format of the input data is specified by the parameters
  ## below. Note that if no format is specified, this method assumes the
  ## `BUNDLE` format. When using the `BUNDLE` format this method ignores the
  ## `Bundle.type` field, except that `history` bundles are rejected, and does
  ## not apply any of the bundle processing semantics for batch or transaction
  ## bundles. Unlike in ExecuteBundle, transaction bundles are not executed
  ## as a single transaction and bundle-internal references are not rewritten.
  ## The bundle is treated as a collection of resources to be written as
  ## provided in `Bundle.entry.resource`, ignoring `Bundle.entry.request`. As
  ## an example, this allows the import of `searchset` bundles produced by a
  ## FHIR search or
  ## Patient-everything operation.
  ## 
  ## This method returns an Operation that can
  ## be used to track the status of the import by calling
  ## GetOperation.
  ## 
  ## Immediate fatal errors appear in the
  ## error field, errors are also logged
  ## to Stackdriver (see [Viewing
  ## logs](/healthcare/docs/how-tos/stackdriver-logging)). Otherwise, when the
  ## operation finishes, a detailed response of type ImportResourcesResponse
  ## is returned in the response field.
  ## The metadata field type for this
  ## operation is OperationMetadata.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the FHIR store to import FHIR resources to. The name should be
  ## in the format of
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/fhirStores/{fhir_store_id}`.
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
  var path_580208 = newJObject()
  var query_580209 = newJObject()
  var body_580210 = newJObject()
  add(query_580209, "upload_protocol", newJString(uploadProtocol))
  add(query_580209, "fields", newJString(fields))
  add(query_580209, "quotaUser", newJString(quotaUser))
  add(path_580208, "name", newJString(name))
  add(query_580209, "alt", newJString(alt))
  add(query_580209, "oauth_token", newJString(oauthToken))
  add(query_580209, "callback", newJString(callback))
  add(query_580209, "access_token", newJString(accessToken))
  add(query_580209, "uploadType", newJString(uploadType))
  add(query_580209, "key", newJString(key))
  add(query_580209, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580210 = body
  add(query_580209, "prettyPrint", newJBool(prettyPrint))
  result = call_580207.call(path_580208, query_580209, nil, nil, body_580210)

var healthcareProjectsLocationsDatasetsFhirStoresImport* = Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_580190(
    name: "healthcareProjectsLocationsDatasetsFhirStoresImport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}:import",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresImport_580191,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresImport_580192,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsCreate_580232 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsCreate_580234(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsCreate_580233(path: JsonNode;
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
  ##         : The name of the project where the server creates the dataset. For
  ## example, `projects/{project_id}/locations/{location_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580235 = path.getOrDefault("parent")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "parent", valid_580235
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
  var valid_580236 = query.getOrDefault("upload_protocol")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "upload_protocol", valid_580236
  var valid_580237 = query.getOrDefault("fields")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "fields", valid_580237
  var valid_580238 = query.getOrDefault("quotaUser")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "quotaUser", valid_580238
  var valid_580239 = query.getOrDefault("alt")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = newJString("json"))
  if valid_580239 != nil:
    section.add "alt", valid_580239
  var valid_580240 = query.getOrDefault("oauth_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "oauth_token", valid_580240
  var valid_580241 = query.getOrDefault("callback")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "callback", valid_580241
  var valid_580242 = query.getOrDefault("access_token")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "access_token", valid_580242
  var valid_580243 = query.getOrDefault("uploadType")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "uploadType", valid_580243
  var valid_580244 = query.getOrDefault("datasetId")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "datasetId", valid_580244
  var valid_580245 = query.getOrDefault("key")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "key", valid_580245
  var valid_580246 = query.getOrDefault("$.xgafv")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = newJString("1"))
  if valid_580246 != nil:
    section.add "$.xgafv", valid_580246
  var valid_580247 = query.getOrDefault("prettyPrint")
  valid_580247 = validateParameter(valid_580247, JBool, required = false,
                                 default = newJBool(true))
  if valid_580247 != nil:
    section.add "prettyPrint", valid_580247
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

proc call*(call_580249: Call_HealthcareProjectsLocationsDatasetsCreate_580232;
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
  let valid = call_580249.validator(path, query, header, formData, body)
  let scheme = call_580249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580249.url(scheme.get, call_580249.host, call_580249.base,
                         call_580249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580249, url, valid)

proc call*(call_580250: Call_HealthcareProjectsLocationsDatasetsCreate_580232;
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
  ##         : The name of the project where the server creates the dataset. For
  ## example, `projects/{project_id}/locations/{location_id}`.
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
  var path_580251 = newJObject()
  var query_580252 = newJObject()
  var body_580253 = newJObject()
  add(query_580252, "upload_protocol", newJString(uploadProtocol))
  add(query_580252, "fields", newJString(fields))
  add(query_580252, "quotaUser", newJString(quotaUser))
  add(query_580252, "alt", newJString(alt))
  add(query_580252, "oauth_token", newJString(oauthToken))
  add(query_580252, "callback", newJString(callback))
  add(query_580252, "access_token", newJString(accessToken))
  add(query_580252, "uploadType", newJString(uploadType))
  add(path_580251, "parent", newJString(parent))
  add(query_580252, "datasetId", newJString(datasetId))
  add(query_580252, "key", newJString(key))
  add(query_580252, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580253 = body
  add(query_580252, "prettyPrint", newJBool(prettyPrint))
  result = call_580250.call(path_580251, query_580252, nil, nil, body_580253)

var healthcareProjectsLocationsDatasetsCreate* = Call_HealthcareProjectsLocationsDatasetsCreate_580232(
    name: "healthcareProjectsLocationsDatasetsCreate", meth: HttpMethod.HttpPost,
    host: "healthcare.googleapis.com", route: "/v1beta1/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsCreate_580233,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsCreate_580234,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsList_580211 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsList_580213(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsList_580212(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the health datasets in the current project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project whose datasets should be listed.
  ## For example, `projects/{project_id}/locations/{location_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580214 = path.getOrDefault("parent")
  valid_580214 = validateParameter(valid_580214, JString, required = true,
                                 default = nil)
  if valid_580214 != nil:
    section.add "parent", valid_580214
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
  var valid_580215 = query.getOrDefault("upload_protocol")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "upload_protocol", valid_580215
  var valid_580216 = query.getOrDefault("fields")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "fields", valid_580216
  var valid_580217 = query.getOrDefault("pageToken")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "pageToken", valid_580217
  var valid_580218 = query.getOrDefault("quotaUser")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "quotaUser", valid_580218
  var valid_580219 = query.getOrDefault("alt")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = newJString("json"))
  if valid_580219 != nil:
    section.add "alt", valid_580219
  var valid_580220 = query.getOrDefault("oauth_token")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "oauth_token", valid_580220
  var valid_580221 = query.getOrDefault("callback")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "callback", valid_580221
  var valid_580222 = query.getOrDefault("access_token")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "access_token", valid_580222
  var valid_580223 = query.getOrDefault("uploadType")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "uploadType", valid_580223
  var valid_580224 = query.getOrDefault("key")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "key", valid_580224
  var valid_580225 = query.getOrDefault("$.xgafv")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = newJString("1"))
  if valid_580225 != nil:
    section.add "$.xgafv", valid_580225
  var valid_580226 = query.getOrDefault("pageSize")
  valid_580226 = validateParameter(valid_580226, JInt, required = false, default = nil)
  if valid_580226 != nil:
    section.add "pageSize", valid_580226
  var valid_580227 = query.getOrDefault("prettyPrint")
  valid_580227 = validateParameter(valid_580227, JBool, required = false,
                                 default = newJBool(true))
  if valid_580227 != nil:
    section.add "prettyPrint", valid_580227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580228: Call_HealthcareProjectsLocationsDatasetsList_580211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the health datasets in the current project.
  ## 
  let valid = call_580228.validator(path, query, header, formData, body)
  let scheme = call_580228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580228.url(scheme.get, call_580228.host, call_580228.base,
                         call_580228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580228, url, valid)

proc call*(call_580229: Call_HealthcareProjectsLocationsDatasetsList_580211;
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
  ##         : The name of the project whose datasets should be listed.
  ## For example, `projects/{project_id}/locations/{location_id}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Capped to 100 if not specified.
  ## May not be larger than 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580230 = newJObject()
  var query_580231 = newJObject()
  add(query_580231, "upload_protocol", newJString(uploadProtocol))
  add(query_580231, "fields", newJString(fields))
  add(query_580231, "pageToken", newJString(pageToken))
  add(query_580231, "quotaUser", newJString(quotaUser))
  add(query_580231, "alt", newJString(alt))
  add(query_580231, "oauth_token", newJString(oauthToken))
  add(query_580231, "callback", newJString(callback))
  add(query_580231, "access_token", newJString(accessToken))
  add(query_580231, "uploadType", newJString(uploadType))
  add(path_580230, "parent", newJString(parent))
  add(query_580231, "key", newJString(key))
  add(query_580231, "$.xgafv", newJString(Xgafv))
  add(query_580231, "pageSize", newJInt(pageSize))
  add(query_580231, "prettyPrint", newJBool(prettyPrint))
  result = call_580229.call(path_580230, query_580231, nil, nil, nil)

var healthcareProjectsLocationsDatasetsList* = Call_HealthcareProjectsLocationsDatasetsList_580211(
    name: "healthcareProjectsLocationsDatasetsList", meth: HttpMethod.HttpGet,
    host: "healthcare.googleapis.com", route: "/v1beta1/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsList_580212, base: "/",
    url: url_HealthcareProjectsLocationsDatasetsList_580213,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580276 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580278(
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
               (kind: ConstantSegment, value: "/dicomStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580277(
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
  var valid_580279 = path.getOrDefault("parent")
  valid_580279 = validateParameter(valid_580279, JString, required = true,
                                 default = nil)
  if valid_580279 != nil:
    section.add "parent", valid_580279
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
  var valid_580280 = query.getOrDefault("upload_protocol")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "upload_protocol", valid_580280
  var valid_580281 = query.getOrDefault("fields")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "fields", valid_580281
  var valid_580282 = query.getOrDefault("quotaUser")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "quotaUser", valid_580282
  var valid_580283 = query.getOrDefault("alt")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = newJString("json"))
  if valid_580283 != nil:
    section.add "alt", valid_580283
  var valid_580284 = query.getOrDefault("oauth_token")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "oauth_token", valid_580284
  var valid_580285 = query.getOrDefault("callback")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "callback", valid_580285
  var valid_580286 = query.getOrDefault("access_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "access_token", valid_580286
  var valid_580287 = query.getOrDefault("uploadType")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "uploadType", valid_580287
  var valid_580288 = query.getOrDefault("key")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "key", valid_580288
  var valid_580289 = query.getOrDefault("$.xgafv")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = newJString("1"))
  if valid_580289 != nil:
    section.add "$.xgafv", valid_580289
  var valid_580290 = query.getOrDefault("dicomStoreId")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "dicomStoreId", valid_580290
  var valid_580291 = query.getOrDefault("prettyPrint")
  valid_580291 = validateParameter(valid_580291, JBool, required = false,
                                 default = newJBool(true))
  if valid_580291 != nil:
    section.add "prettyPrint", valid_580291
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

proc call*(call_580293: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new DICOM store within the parent dataset.
  ## 
  let valid = call_580293.validator(path, query, header, formData, body)
  let scheme = call_580293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580293.url(scheme.get, call_580293.host, call_580293.base,
                         call_580293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580293, url, valid)

proc call*(call_580294: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580276;
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
  var path_580295 = newJObject()
  var query_580296 = newJObject()
  var body_580297 = newJObject()
  add(query_580296, "upload_protocol", newJString(uploadProtocol))
  add(query_580296, "fields", newJString(fields))
  add(query_580296, "quotaUser", newJString(quotaUser))
  add(query_580296, "alt", newJString(alt))
  add(query_580296, "oauth_token", newJString(oauthToken))
  add(query_580296, "callback", newJString(callback))
  add(query_580296, "access_token", newJString(accessToken))
  add(query_580296, "uploadType", newJString(uploadType))
  add(path_580295, "parent", newJString(parent))
  add(query_580296, "key", newJString(key))
  add(query_580296, "$.xgafv", newJString(Xgafv))
  add(query_580296, "dicomStoreId", newJString(dicomStoreId))
  if body != nil:
    body_580297 = body
  add(query_580296, "prettyPrint", newJBool(prettyPrint))
  result = call_580294.call(path_580295, query_580296, nil, nil, body_580297)

var healthcareProjectsLocationsDatasetsDicomStoresCreate* = Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580276(
    name: "healthcareProjectsLocationsDatasetsDicomStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580277,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_580278,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresList_580254 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresList_580256(
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
               (kind: ConstantSegment, value: "/dicomStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresList_580255(
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
  var valid_580257 = path.getOrDefault("parent")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "parent", valid_580257
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
  ## Only filtering on labels is supported. For example, `labels.key=value`.
  section = newJObject()
  var valid_580258 = query.getOrDefault("upload_protocol")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "upload_protocol", valid_580258
  var valid_580259 = query.getOrDefault("fields")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "fields", valid_580259
  var valid_580260 = query.getOrDefault("pageToken")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "pageToken", valid_580260
  var valid_580261 = query.getOrDefault("quotaUser")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "quotaUser", valid_580261
  var valid_580262 = query.getOrDefault("alt")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = newJString("json"))
  if valid_580262 != nil:
    section.add "alt", valid_580262
  var valid_580263 = query.getOrDefault("oauth_token")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "oauth_token", valid_580263
  var valid_580264 = query.getOrDefault("callback")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "callback", valid_580264
  var valid_580265 = query.getOrDefault("access_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "access_token", valid_580265
  var valid_580266 = query.getOrDefault("uploadType")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "uploadType", valid_580266
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("$.xgafv")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = newJString("1"))
  if valid_580268 != nil:
    section.add "$.xgafv", valid_580268
  var valid_580269 = query.getOrDefault("pageSize")
  valid_580269 = validateParameter(valid_580269, JInt, required = false, default = nil)
  if valid_580269 != nil:
    section.add "pageSize", valid_580269
  var valid_580270 = query.getOrDefault("prettyPrint")
  valid_580270 = validateParameter(valid_580270, JBool, required = false,
                                 default = newJBool(true))
  if valid_580270 != nil:
    section.add "prettyPrint", valid_580270
  var valid_580271 = query.getOrDefault("filter")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "filter", valid_580271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580272: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_580254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the DICOM stores in the given dataset.
  ## 
  let valid = call_580272.validator(path, query, header, formData, body)
  let scheme = call_580272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580272.url(scheme.get, call_580272.host, call_580272.base,
                         call_580272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580272, url, valid)

proc call*(call_580273: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_580254;
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
  ## Only filtering on labels is supported. For example, `labels.key=value`.
  var path_580274 = newJObject()
  var query_580275 = newJObject()
  add(query_580275, "upload_protocol", newJString(uploadProtocol))
  add(query_580275, "fields", newJString(fields))
  add(query_580275, "pageToken", newJString(pageToken))
  add(query_580275, "quotaUser", newJString(quotaUser))
  add(query_580275, "alt", newJString(alt))
  add(query_580275, "oauth_token", newJString(oauthToken))
  add(query_580275, "callback", newJString(callback))
  add(query_580275, "access_token", newJString(accessToken))
  add(query_580275, "uploadType", newJString(uploadType))
  add(path_580274, "parent", newJString(parent))
  add(query_580275, "key", newJString(key))
  add(query_580275, "$.xgafv", newJString(Xgafv))
  add(query_580275, "pageSize", newJInt(pageSize))
  add(query_580275, "prettyPrint", newJBool(prettyPrint))
  add(query_580275, "filter", newJString(filter))
  result = call_580273.call(path_580274, query_580275, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresList* = Call_HealthcareProjectsLocationsDatasetsDicomStoresList_580254(
    name: "healthcareProjectsLocationsDatasetsDicomStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresList_580255,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresList_580256,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_580318 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_580320(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_580319(
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the StoreInstances DICOMweb request (for example,
  ## `studies/[{study_uid}]`). Note that the `study_uid` is optional.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580321 = path.getOrDefault("parent")
  valid_580321 = validateParameter(valid_580321, JString, required = true,
                                 default = nil)
  if valid_580321 != nil:
    section.add "parent", valid_580321
  var valid_580322 = path.getOrDefault("dicomWebPath")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "dicomWebPath", valid_580322
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
  var valid_580323 = query.getOrDefault("upload_protocol")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "upload_protocol", valid_580323
  var valid_580324 = query.getOrDefault("fields")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "fields", valid_580324
  var valid_580325 = query.getOrDefault("quotaUser")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "quotaUser", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("oauth_token")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "oauth_token", valid_580327
  var valid_580328 = query.getOrDefault("callback")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "callback", valid_580328
  var valid_580329 = query.getOrDefault("access_token")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "access_token", valid_580329
  var valid_580330 = query.getOrDefault("uploadType")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "uploadType", valid_580330
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("$.xgafv")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = newJString("1"))
  if valid_580332 != nil:
    section.add "$.xgafv", valid_580332
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580335: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_580318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## StoreInstances stores DICOM instances associated with study instance unique
  ## identifiers (SUID). See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.5.
  ## 
  let valid = call_580335.validator(path, query, header, formData, body)
  let scheme = call_580335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580335.url(scheme.get, call_580335.host, call_580335.base,
                         call_580335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580335, url, valid)

proc call*(call_580336: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_580318;
          parent: string; dicomWebPath: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances
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
  ##         : The name of the DICOM store that is being accessed (for example,
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
  ##               : The path of the StoreInstances DICOMweb request (for example,
  ## `studies/[{study_uid}]`). Note that the `study_uid` is optional.
  var path_580337 = newJObject()
  var query_580338 = newJObject()
  var body_580339 = newJObject()
  add(query_580338, "upload_protocol", newJString(uploadProtocol))
  add(query_580338, "fields", newJString(fields))
  add(query_580338, "quotaUser", newJString(quotaUser))
  add(query_580338, "alt", newJString(alt))
  add(query_580338, "oauth_token", newJString(oauthToken))
  add(query_580338, "callback", newJString(callback))
  add(query_580338, "access_token", newJString(accessToken))
  add(query_580338, "uploadType", newJString(uploadType))
  add(path_580337, "parent", newJString(parent))
  add(query_580338, "key", newJString(key))
  add(query_580338, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580339 = body
  add(query_580338, "prettyPrint", newJBool(prettyPrint))
  add(path_580337, "dicomWebPath", newJString(dicomWebPath))
  result = call_580336.call(path_580337, query_580338, nil, nil, body_580339)

var healthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances* = Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_580318(name: "healthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_580319,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_580320,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered_580298 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered_580300(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered_580299(
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the RetrieveRenderedFrames DICOMweb request (for example,
  ## 
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}/frames/{frame_list}/rendered`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580301 = path.getOrDefault("parent")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "parent", valid_580301
  var valid_580302 = path.getOrDefault("dicomWebPath")
  valid_580302 = validateParameter(valid_580302, JString, required = true,
                                 default = nil)
  if valid_580302 != nil:
    section.add "dicomWebPath", valid_580302
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
  var valid_580303 = query.getOrDefault("upload_protocol")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "upload_protocol", valid_580303
  var valid_580304 = query.getOrDefault("fields")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "fields", valid_580304
  var valid_580305 = query.getOrDefault("quotaUser")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "quotaUser", valid_580305
  var valid_580306 = query.getOrDefault("alt")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = newJString("json"))
  if valid_580306 != nil:
    section.add "alt", valid_580306
  var valid_580307 = query.getOrDefault("oauth_token")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "oauth_token", valid_580307
  var valid_580308 = query.getOrDefault("callback")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "callback", valid_580308
  var valid_580309 = query.getOrDefault("access_token")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "access_token", valid_580309
  var valid_580310 = query.getOrDefault("uploadType")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "uploadType", valid_580310
  var valid_580311 = query.getOrDefault("key")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "key", valid_580311
  var valid_580312 = query.getOrDefault("$.xgafv")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = newJString("1"))
  if valid_580312 != nil:
    section.add "$.xgafv", valid_580312
  var valid_580313 = query.getOrDefault("prettyPrint")
  valid_580313 = validateParameter(valid_580313, JBool, required = false,
                                 default = newJBool(true))
  if valid_580313 != nil:
    section.add "prettyPrint", valid_580313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580314: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered_580298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RetrieveRenderedFrames returns instances associated with the given study,
  ## series, SOP Instance UID and frame numbers in an acceptable Rendered Media
  ## Type. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
  ## 
  let valid = call_580314.validator(path, query, header, formData, body)
  let scheme = call_580314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580314.url(scheme.get, call_580314.host, call_580314.base,
                         call_580314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580314, url, valid)

proc call*(call_580315: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered_580298;
          parent: string; dicomWebPath: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dicomWebPath: string (required)
  ##               : The path of the RetrieveRenderedFrames DICOMweb request (for example,
  ## 
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}/frames/{frame_list}/rendered`).
  var path_580316 = newJObject()
  var query_580317 = newJObject()
  add(query_580317, "upload_protocol", newJString(uploadProtocol))
  add(query_580317, "fields", newJString(fields))
  add(query_580317, "quotaUser", newJString(quotaUser))
  add(query_580317, "alt", newJString(alt))
  add(query_580317, "oauth_token", newJString(oauthToken))
  add(query_580317, "callback", newJString(callback))
  add(query_580317, "access_token", newJString(accessToken))
  add(query_580317, "uploadType", newJString(uploadType))
  add(path_580316, "parent", newJString(parent))
  add(query_580317, "key", newJString(key))
  add(query_580317, "$.xgafv", newJString(Xgafv))
  add(query_580317, "prettyPrint", newJBool(prettyPrint))
  add(path_580316, "dicomWebPath", newJString(dicomWebPath))
  result = call_580315.call(path_580316, query_580317, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered* = Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered_580298(name: "healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered_580299,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveRendered_580300,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_580340 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_580342(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "dicomWebPath" in path, "`dicomWebPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dicomWeb/"),
               (kind: VariableSegment, value: "dicomWebPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_580341(
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   dicomWebPath: JString (required)
  ##               : The path of the DeleteInstance request (for example,
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580343 = path.getOrDefault("parent")
  valid_580343 = validateParameter(valid_580343, JString, required = true,
                                 default = nil)
  if valid_580343 != nil:
    section.add "parent", valid_580343
  var valid_580344 = path.getOrDefault("dicomWebPath")
  valid_580344 = validateParameter(valid_580344, JString, required = true,
                                 default = nil)
  if valid_580344 != nil:
    section.add "dicomWebPath", valid_580344
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
  var valid_580345 = query.getOrDefault("upload_protocol")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "upload_protocol", valid_580345
  var valid_580346 = query.getOrDefault("fields")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "fields", valid_580346
  var valid_580347 = query.getOrDefault("quotaUser")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "quotaUser", valid_580347
  var valid_580348 = query.getOrDefault("alt")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = newJString("json"))
  if valid_580348 != nil:
    section.add "alt", valid_580348
  var valid_580349 = query.getOrDefault("oauth_token")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "oauth_token", valid_580349
  var valid_580350 = query.getOrDefault("callback")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "callback", valid_580350
  var valid_580351 = query.getOrDefault("access_token")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "access_token", valid_580351
  var valid_580352 = query.getOrDefault("uploadType")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "uploadType", valid_580352
  var valid_580353 = query.getOrDefault("key")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "key", valid_580353
  var valid_580354 = query.getOrDefault("$.xgafv")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = newJString("1"))
  if valid_580354 != nil:
    section.add "$.xgafv", valid_580354
  var valid_580355 = query.getOrDefault("prettyPrint")
  valid_580355 = validateParameter(valid_580355, JBool, required = false,
                                 default = newJBool(true))
  if valid_580355 != nil:
    section.add "prettyPrint", valid_580355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580356: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_580340;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## DeleteInstance deletes an instance associated with the given study, series,
  ## and SOP Instance UID. Delete requests are equivalent to the GET requests
  ## specified in the WADO-RS standard.
  ## 
  let valid = call_580356.validator(path, query, header, formData, body)
  let scheme = call_580356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580356.url(scheme.get, call_580356.host, call_580356.base,
                         call_580356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580356, url, valid)

proc call*(call_580357: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_580340;
          parent: string; dicomWebPath: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete
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
  ##         : The name of the DICOM store that is being accessed (for example,
  ## 
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}/dicomStores/{dicom_store_id}`).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dicomWebPath: string (required)
  ##               : The path of the DeleteInstance request (for example,
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}`).
  var path_580358 = newJObject()
  var query_580359 = newJObject()
  add(query_580359, "upload_protocol", newJString(uploadProtocol))
  add(query_580359, "fields", newJString(fields))
  add(query_580359, "quotaUser", newJString(quotaUser))
  add(query_580359, "alt", newJString(alt))
  add(query_580359, "oauth_token", newJString(oauthToken))
  add(query_580359, "callback", newJString(callback))
  add(query_580359, "access_token", newJString(accessToken))
  add(query_580359, "uploadType", newJString(uploadType))
  add(path_580358, "parent", newJString(parent))
  add(query_580359, "key", newJString(key))
  add(query_580359, "$.xgafv", newJString(Xgafv))
  add(query_580359, "prettyPrint", newJBool(prettyPrint))
  add(path_580358, "dicomWebPath", newJString(dicomWebPath))
  result = call_580357.call(path_580358, query_580359, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete* = Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_580340(name: "healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_580341,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_580342,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580360 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580362(
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
               (kind: ConstantSegment, value: "/fhir")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580361(
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
  var valid_580366 = query.getOrDefault("quotaUser")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "quotaUser", valid_580366
  var valid_580367 = query.getOrDefault("alt")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = newJString("json"))
  if valid_580367 != nil:
    section.add "alt", valid_580367
  var valid_580368 = query.getOrDefault("oauth_token")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "oauth_token", valid_580368
  var valid_580369 = query.getOrDefault("callback")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "callback", valid_580369
  var valid_580370 = query.getOrDefault("access_token")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "access_token", valid_580370
  var valid_580371 = query.getOrDefault("uploadType")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "uploadType", valid_580371
  var valid_580372 = query.getOrDefault("key")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "key", valid_580372
  var valid_580373 = query.getOrDefault("$.xgafv")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = newJString("1"))
  if valid_580373 != nil:
    section.add "$.xgafv", valid_580373
  var valid_580374 = query.getOrDefault("prettyPrint")
  valid_580374 = validateParameter(valid_580374, JBool, required = false,
                                 default = newJBool(true))
  if valid_580374 != nil:
    section.add "prettyPrint", valid_580374
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

proc call*(call_580376: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580360;
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
  let valid = call_580376.validator(path, query, header, formData, body)
  let scheme = call_580376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580376.url(scheme.get, call_580376.host, call_580376.base,
                         call_580376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580376, url, valid)

proc call*(call_580377: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580360;
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
  var path_580378 = newJObject()
  var query_580379 = newJObject()
  var body_580380 = newJObject()
  add(query_580379, "upload_protocol", newJString(uploadProtocol))
  add(query_580379, "fields", newJString(fields))
  add(query_580379, "quotaUser", newJString(quotaUser))
  add(query_580379, "alt", newJString(alt))
  add(query_580379, "oauth_token", newJString(oauthToken))
  add(query_580379, "callback", newJString(callback))
  add(query_580379, "access_token", newJString(accessToken))
  add(query_580379, "uploadType", newJString(uploadType))
  add(path_580378, "parent", newJString(parent))
  add(query_580379, "key", newJString(key))
  add(query_580379, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580380 = body
  add(query_580379, "prettyPrint", newJBool(prettyPrint))
  result = call_580377.call(path_580378, query_580379, nil, nil, body_580380)

var healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580360(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580361,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_580362,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580381 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580383(
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
               (kind: ConstantSegment, value: "/fhir/Observation/$lastn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580382(
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
  var valid_580384 = path.getOrDefault("parent")
  valid_580384 = validateParameter(valid_580384, JString, required = true,
                                 default = nil)
  if valid_580384 != nil:
    section.add "parent", valid_580384
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
  var valid_580385 = query.getOrDefault("upload_protocol")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "upload_protocol", valid_580385
  var valid_580386 = query.getOrDefault("fields")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "fields", valid_580386
  var valid_580387 = query.getOrDefault("quotaUser")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "quotaUser", valid_580387
  var valid_580388 = query.getOrDefault("alt")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("json"))
  if valid_580388 != nil:
    section.add "alt", valid_580388
  var valid_580389 = query.getOrDefault("oauth_token")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "oauth_token", valid_580389
  var valid_580390 = query.getOrDefault("callback")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "callback", valid_580390
  var valid_580391 = query.getOrDefault("access_token")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "access_token", valid_580391
  var valid_580392 = query.getOrDefault("uploadType")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "uploadType", valid_580392
  var valid_580393 = query.getOrDefault("key")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "key", valid_580393
  var valid_580394 = query.getOrDefault("$.xgafv")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = newJString("1"))
  if valid_580394 != nil:
    section.add "$.xgafv", valid_580394
  var valid_580395 = query.getOrDefault("prettyPrint")
  valid_580395 = validateParameter(valid_580395, JBool, required = false,
                                 default = newJBool(true))
  if valid_580395 != nil:
    section.add "prettyPrint", valid_580395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580396: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580381;
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
  let valid = call_580396.validator(path, query, header, formData, body)
  let scheme = call_580396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580396.url(scheme.get, call_580396.host, call_580396.base,
                         call_580396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580396, url, valid)

proc call*(call_580397: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580381;
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
  var path_580398 = newJObject()
  var query_580399 = newJObject()
  add(query_580399, "upload_protocol", newJString(uploadProtocol))
  add(query_580399, "fields", newJString(fields))
  add(query_580399, "quotaUser", newJString(quotaUser))
  add(query_580399, "alt", newJString(alt))
  add(query_580399, "oauth_token", newJString(oauthToken))
  add(query_580399, "callback", newJString(callback))
  add(query_580399, "access_token", newJString(accessToken))
  add(query_580399, "uploadType", newJString(uploadType))
  add(path_580398, "parent", newJString(parent))
  add(query_580399, "key", newJString(key))
  add(query_580399, "$.xgafv", newJString(Xgafv))
  add(query_580399, "prettyPrint", newJBool(prettyPrint))
  result = call_580397.call(path_580398, query_580399, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580381(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/Observation/$lastn", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580382,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_580383,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580400 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580402(
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
               (kind: ConstantSegment, value: "/fhir/_search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580401(
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
  var valid_580403 = path.getOrDefault("parent")
  valid_580403 = validateParameter(valid_580403, JString, required = true,
                                 default = nil)
  if valid_580403 != nil:
    section.add "parent", valid_580403
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
  var valid_580404 = query.getOrDefault("upload_protocol")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "upload_protocol", valid_580404
  var valid_580405 = query.getOrDefault("fields")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "fields", valid_580405
  var valid_580406 = query.getOrDefault("quotaUser")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "quotaUser", valid_580406
  var valid_580407 = query.getOrDefault("alt")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = newJString("json"))
  if valid_580407 != nil:
    section.add "alt", valid_580407
  var valid_580408 = query.getOrDefault("oauth_token")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "oauth_token", valid_580408
  var valid_580409 = query.getOrDefault("callback")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "callback", valid_580409
  var valid_580410 = query.getOrDefault("access_token")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "access_token", valid_580410
  var valid_580411 = query.getOrDefault("uploadType")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "uploadType", valid_580411
  var valid_580412 = query.getOrDefault("key")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "key", valid_580412
  var valid_580413 = query.getOrDefault("$.xgafv")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = newJString("1"))
  if valid_580413 != nil:
    section.add "$.xgafv", valid_580413
  var valid_580414 = query.getOrDefault("prettyPrint")
  valid_580414 = validateParameter(valid_580414, JBool, required = false,
                                 default = newJBool(true))
  if valid_580414 != nil:
    section.add "prettyPrint", valid_580414
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

proc call*(call_580416: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580400;
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
  let valid = call_580416.validator(path, query, header, formData, body)
  let scheme = call_580416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580416.url(scheme.get, call_580416.host, call_580416.base,
                         call_580416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580416, url, valid)

proc call*(call_580417: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580400;
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
  var path_580418 = newJObject()
  var query_580419 = newJObject()
  var body_580420 = newJObject()
  add(query_580419, "upload_protocol", newJString(uploadProtocol))
  add(query_580419, "fields", newJString(fields))
  add(query_580419, "quotaUser", newJString(quotaUser))
  add(query_580419, "alt", newJString(alt))
  add(query_580419, "oauth_token", newJString(oauthToken))
  add(query_580419, "callback", newJString(callback))
  add(query_580419, "access_token", newJString(accessToken))
  add(query_580419, "uploadType", newJString(uploadType))
  add(path_580418, "parent", newJString(parent))
  add(query_580419, "key", newJString(key))
  add(query_580419, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580420 = body
  add(query_580419, "prettyPrint", newJBool(prettyPrint))
  result = call_580417.call(path_580418, query_580419, nil, nil, body_580420)

var healthcareProjectsLocationsDatasetsFhirStoresFhirSearch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580400(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirSearch",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/_search", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580401,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_580402,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580421 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580423(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580422(
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
  var valid_580424 = path.getOrDefault("type")
  valid_580424 = validateParameter(valid_580424, JString, required = true,
                                 default = nil)
  if valid_580424 != nil:
    section.add "type", valid_580424
  var valid_580425 = path.getOrDefault("parent")
  valid_580425 = validateParameter(valid_580425, JString, required = true,
                                 default = nil)
  if valid_580425 != nil:
    section.add "parent", valid_580425
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
  var valid_580426 = query.getOrDefault("upload_protocol")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "upload_protocol", valid_580426
  var valid_580427 = query.getOrDefault("fields")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "fields", valid_580427
  var valid_580428 = query.getOrDefault("quotaUser")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "quotaUser", valid_580428
  var valid_580429 = query.getOrDefault("alt")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = newJString("json"))
  if valid_580429 != nil:
    section.add "alt", valid_580429
  var valid_580430 = query.getOrDefault("oauth_token")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "oauth_token", valid_580430
  var valid_580431 = query.getOrDefault("callback")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "callback", valid_580431
  var valid_580432 = query.getOrDefault("access_token")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "access_token", valid_580432
  var valid_580433 = query.getOrDefault("uploadType")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "uploadType", valid_580433
  var valid_580434 = query.getOrDefault("key")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "key", valid_580434
  var valid_580435 = query.getOrDefault("$.xgafv")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = newJString("1"))
  if valid_580435 != nil:
    section.add "$.xgafv", valid_580435
  var valid_580436 = query.getOrDefault("prettyPrint")
  valid_580436 = validateParameter(valid_580436, JBool, required = false,
                                 default = newJBool(true))
  if valid_580436 != nil:
    section.add "prettyPrint", valid_580436
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

proc call*(call_580438: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580421;
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
  let valid = call_580438.validator(path, query, header, formData, body)
  let scheme = call_580438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580438.url(scheme.get, call_580438.host, call_580438.base,
                         call_580438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580438, url, valid)

proc call*(call_580439: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580421;
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
  var path_580440 = newJObject()
  var query_580441 = newJObject()
  var body_580442 = newJObject()
  add(path_580440, "type", newJString(`type`))
  add(query_580441, "upload_protocol", newJString(uploadProtocol))
  add(query_580441, "fields", newJString(fields))
  add(query_580441, "quotaUser", newJString(quotaUser))
  add(query_580441, "alt", newJString(alt))
  add(query_580441, "oauth_token", newJString(oauthToken))
  add(query_580441, "callback", newJString(callback))
  add(query_580441, "access_token", newJString(accessToken))
  add(query_580441, "uploadType", newJString(uploadType))
  add(path_580440, "parent", newJString(parent))
  add(query_580441, "key", newJString(key))
  add(query_580441, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580442 = body
  add(query_580441, "prettyPrint", newJBool(prettyPrint))
  result = call_580439.call(path_580440, query_580441, nil, nil, body_580442)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580421(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate",
    meth: HttpMethod.HttpPut, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580422,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_580423,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580443 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580445(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580444(
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
  var valid_580446 = path.getOrDefault("type")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "type", valid_580446
  var valid_580447 = path.getOrDefault("parent")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "parent", valid_580447
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
  var valid_580448 = query.getOrDefault("upload_protocol")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "upload_protocol", valid_580448
  var valid_580449 = query.getOrDefault("fields")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "fields", valid_580449
  var valid_580450 = query.getOrDefault("quotaUser")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "quotaUser", valid_580450
  var valid_580451 = query.getOrDefault("alt")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = newJString("json"))
  if valid_580451 != nil:
    section.add "alt", valid_580451
  var valid_580452 = query.getOrDefault("oauth_token")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "oauth_token", valid_580452
  var valid_580453 = query.getOrDefault("callback")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "callback", valid_580453
  var valid_580454 = query.getOrDefault("access_token")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "access_token", valid_580454
  var valid_580455 = query.getOrDefault("uploadType")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "uploadType", valid_580455
  var valid_580456 = query.getOrDefault("key")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "key", valid_580456
  var valid_580457 = query.getOrDefault("$.xgafv")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = newJString("1"))
  if valid_580457 != nil:
    section.add "$.xgafv", valid_580457
  var valid_580458 = query.getOrDefault("prettyPrint")
  valid_580458 = validateParameter(valid_580458, JBool, required = false,
                                 default = newJBool(true))
  if valid_580458 != nil:
    section.add "prettyPrint", valid_580458
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

proc call*(call_580460: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580443;
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
  let valid = call_580460.validator(path, query, header, formData, body)
  let scheme = call_580460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580460.url(scheme.get, call_580460.host, call_580460.base,
                         call_580460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580460, url, valid)

proc call*(call_580461: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580443;
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
  var path_580462 = newJObject()
  var query_580463 = newJObject()
  var body_580464 = newJObject()
  add(path_580462, "type", newJString(`type`))
  add(query_580463, "upload_protocol", newJString(uploadProtocol))
  add(query_580463, "fields", newJString(fields))
  add(query_580463, "quotaUser", newJString(quotaUser))
  add(query_580463, "alt", newJString(alt))
  add(query_580463, "oauth_token", newJString(oauthToken))
  add(query_580463, "callback", newJString(callback))
  add(query_580463, "access_token", newJString(accessToken))
  add(query_580463, "uploadType", newJString(uploadType))
  add(path_580462, "parent", newJString(parent))
  add(query_580463, "key", newJString(key))
  add(query_580463, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580464 = body
  add(query_580463, "prettyPrint", newJBool(prettyPrint))
  result = call_580461.call(path_580462, query_580463, nil, nil, body_580464)

var healthcareProjectsLocationsDatasetsFhirStoresFhirCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580443(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580444,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_580445,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580485 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580487(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580486(
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
  var valid_580488 = path.getOrDefault("type")
  valid_580488 = validateParameter(valid_580488, JString, required = true,
                                 default = nil)
  if valid_580488 != nil:
    section.add "type", valid_580488
  var valid_580489 = path.getOrDefault("parent")
  valid_580489 = validateParameter(valid_580489, JString, required = true,
                                 default = nil)
  if valid_580489 != nil:
    section.add "parent", valid_580489
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
  var valid_580490 = query.getOrDefault("upload_protocol")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "upload_protocol", valid_580490
  var valid_580491 = query.getOrDefault("fields")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "fields", valid_580491
  var valid_580492 = query.getOrDefault("quotaUser")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "quotaUser", valid_580492
  var valid_580493 = query.getOrDefault("alt")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = newJString("json"))
  if valid_580493 != nil:
    section.add "alt", valid_580493
  var valid_580494 = query.getOrDefault("oauth_token")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "oauth_token", valid_580494
  var valid_580495 = query.getOrDefault("callback")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "callback", valid_580495
  var valid_580496 = query.getOrDefault("access_token")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "access_token", valid_580496
  var valid_580497 = query.getOrDefault("uploadType")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "uploadType", valid_580497
  var valid_580498 = query.getOrDefault("key")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "key", valid_580498
  var valid_580499 = query.getOrDefault("$.xgafv")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = newJString("1"))
  if valid_580499 != nil:
    section.add "$.xgafv", valid_580499
  var valid_580500 = query.getOrDefault("prettyPrint")
  valid_580500 = validateParameter(valid_580500, JBool, required = false,
                                 default = newJBool(true))
  if valid_580500 != nil:
    section.add "prettyPrint", valid_580500
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

proc call*(call_580502: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580485;
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
  let valid = call_580502.validator(path, query, header, formData, body)
  let scheme = call_580502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580502.url(scheme.get, call_580502.host, call_580502.base,
                         call_580502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580502, url, valid)

proc call*(call_580503: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580485;
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
  var path_580504 = newJObject()
  var query_580505 = newJObject()
  var body_580506 = newJObject()
  add(path_580504, "type", newJString(`type`))
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
  if body != nil:
    body_580506 = body
  add(query_580505, "prettyPrint", newJBool(prettyPrint))
  result = call_580503.call(path_580504, query_580505, nil, nil, body_580506)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580485(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580486,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_580487,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580465 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580467(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fhir/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580466(
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
  var valid_580468 = path.getOrDefault("type")
  valid_580468 = validateParameter(valid_580468, JString, required = true,
                                 default = nil)
  if valid_580468 != nil:
    section.add "type", valid_580468
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
  if body != nil:
    result.add "body", body

proc call*(call_580481: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580465;
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
  let valid = call_580481.validator(path, query, header, formData, body)
  let scheme = call_580481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580481.url(scheme.get, call_580481.host, call_580481.base,
                         call_580481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580481, url, valid)

proc call*(call_580482: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580465;
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
  var path_580483 = newJObject()
  var query_580484 = newJObject()
  add(path_580483, "type", newJString(`type`))
  add(query_580484, "upload_protocol", newJString(uploadProtocol))
  add(query_580484, "fields", newJString(fields))
  add(query_580484, "quotaUser", newJString(quotaUser))
  add(query_580484, "alt", newJString(alt))
  add(query_580484, "oauth_token", newJString(oauthToken))
  add(query_580484, "callback", newJString(callback))
  add(query_580484, "access_token", newJString(accessToken))
  add(query_580484, "uploadType", newJString(uploadType))
  add(path_580483, "parent", newJString(parent))
  add(query_580484, "key", newJString(key))
  add(query_580484, "$.xgafv", newJString(Xgafv))
  add(query_580484, "prettyPrint", newJBool(prettyPrint))
  result = call_580482.call(path_580483, query_580484, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580465(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580466,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_580467,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580529 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580531(
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
               (kind: ConstantSegment, value: "/fhirStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580530(
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
  var valid_580532 = path.getOrDefault("parent")
  valid_580532 = validateParameter(valid_580532, JString, required = true,
                                 default = nil)
  if valid_580532 != nil:
    section.add "parent", valid_580532
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
  var valid_580533 = query.getOrDefault("upload_protocol")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "upload_protocol", valid_580533
  var valid_580534 = query.getOrDefault("fields")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "fields", valid_580534
  var valid_580535 = query.getOrDefault("quotaUser")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "quotaUser", valid_580535
  var valid_580536 = query.getOrDefault("alt")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = newJString("json"))
  if valid_580536 != nil:
    section.add "alt", valid_580536
  var valid_580537 = query.getOrDefault("oauth_token")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "oauth_token", valid_580537
  var valid_580538 = query.getOrDefault("callback")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "callback", valid_580538
  var valid_580539 = query.getOrDefault("access_token")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "access_token", valid_580539
  var valid_580540 = query.getOrDefault("uploadType")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "uploadType", valid_580540
  var valid_580541 = query.getOrDefault("fhirStoreId")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "fhirStoreId", valid_580541
  var valid_580542 = query.getOrDefault("key")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "key", valid_580542
  var valid_580543 = query.getOrDefault("$.xgafv")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = newJString("1"))
  if valid_580543 != nil:
    section.add "$.xgafv", valid_580543
  var valid_580544 = query.getOrDefault("prettyPrint")
  valid_580544 = validateParameter(valid_580544, JBool, required = false,
                                 default = newJBool(true))
  if valid_580544 != nil:
    section.add "prettyPrint", valid_580544
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

proc call*(call_580546: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580529;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new FHIR store within the parent dataset.
  ## 
  let valid = call_580546.validator(path, query, header, formData, body)
  let scheme = call_580546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580546.url(scheme.get, call_580546.host, call_580546.base,
                         call_580546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580546, url, valid)

proc call*(call_580547: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580529;
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
  var path_580548 = newJObject()
  var query_580549 = newJObject()
  var body_580550 = newJObject()
  add(query_580549, "upload_protocol", newJString(uploadProtocol))
  add(query_580549, "fields", newJString(fields))
  add(query_580549, "quotaUser", newJString(quotaUser))
  add(query_580549, "alt", newJString(alt))
  add(query_580549, "oauth_token", newJString(oauthToken))
  add(query_580549, "callback", newJString(callback))
  add(query_580549, "access_token", newJString(accessToken))
  add(query_580549, "uploadType", newJString(uploadType))
  add(path_580548, "parent", newJString(parent))
  add(query_580549, "fhirStoreId", newJString(fhirStoreId))
  add(query_580549, "key", newJString(key))
  add(query_580549, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580550 = body
  add(query_580549, "prettyPrint", newJBool(prettyPrint))
  result = call_580547.call(path_580548, query_580549, nil, nil, body_580550)

var healthcareProjectsLocationsDatasetsFhirStoresCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580529(
    name: "healthcareProjectsLocationsDatasetsFhirStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580530,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_580531,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresList_580507 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresList_580509(
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
               (kind: ConstantSegment, value: "/fhirStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresList_580508(
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
  var valid_580510 = path.getOrDefault("parent")
  valid_580510 = validateParameter(valid_580510, JString, required = true,
                                 default = nil)
  if valid_580510 != nil:
    section.add "parent", valid_580510
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
  var valid_580511 = query.getOrDefault("upload_protocol")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "upload_protocol", valid_580511
  var valid_580512 = query.getOrDefault("fields")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "fields", valid_580512
  var valid_580513 = query.getOrDefault("pageToken")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "pageToken", valid_580513
  var valid_580514 = query.getOrDefault("quotaUser")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "quotaUser", valid_580514
  var valid_580515 = query.getOrDefault("alt")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = newJString("json"))
  if valid_580515 != nil:
    section.add "alt", valid_580515
  var valid_580516 = query.getOrDefault("oauth_token")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "oauth_token", valid_580516
  var valid_580517 = query.getOrDefault("callback")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "callback", valid_580517
  var valid_580518 = query.getOrDefault("access_token")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "access_token", valid_580518
  var valid_580519 = query.getOrDefault("uploadType")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "uploadType", valid_580519
  var valid_580520 = query.getOrDefault("key")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "key", valid_580520
  var valid_580521 = query.getOrDefault("$.xgafv")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = newJString("1"))
  if valid_580521 != nil:
    section.add "$.xgafv", valid_580521
  var valid_580522 = query.getOrDefault("pageSize")
  valid_580522 = validateParameter(valid_580522, JInt, required = false, default = nil)
  if valid_580522 != nil:
    section.add "pageSize", valid_580522
  var valid_580523 = query.getOrDefault("prettyPrint")
  valid_580523 = validateParameter(valid_580523, JBool, required = false,
                                 default = newJBool(true))
  if valid_580523 != nil:
    section.add "prettyPrint", valid_580523
  var valid_580524 = query.getOrDefault("filter")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "filter", valid_580524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580525: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_580507;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the FHIR stores in the given dataset.
  ## 
  let valid = call_580525.validator(path, query, header, formData, body)
  let scheme = call_580525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580525.url(scheme.get, call_580525.host, call_580525.base,
                         call_580525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580525, url, valid)

proc call*(call_580526: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_580507;
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
  var path_580527 = newJObject()
  var query_580528 = newJObject()
  add(query_580528, "upload_protocol", newJString(uploadProtocol))
  add(query_580528, "fields", newJString(fields))
  add(query_580528, "pageToken", newJString(pageToken))
  add(query_580528, "quotaUser", newJString(quotaUser))
  add(query_580528, "alt", newJString(alt))
  add(query_580528, "oauth_token", newJString(oauthToken))
  add(query_580528, "callback", newJString(callback))
  add(query_580528, "access_token", newJString(accessToken))
  add(query_580528, "uploadType", newJString(uploadType))
  add(path_580527, "parent", newJString(parent))
  add(query_580528, "key", newJString(key))
  add(query_580528, "$.xgafv", newJString(Xgafv))
  add(query_580528, "pageSize", newJInt(pageSize))
  add(query_580528, "prettyPrint", newJBool(prettyPrint))
  add(query_580528, "filter", newJString(filter))
  result = call_580526.call(path_580527, query_580528, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresList* = Call_HealthcareProjectsLocationsDatasetsFhirStoresList_580507(
    name: "healthcareProjectsLocationsDatasetsFhirStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresList_580508,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresList_580509,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580573 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580575(
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
               (kind: ConstantSegment, value: "/hl7V2Stores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580574(
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
  var valid_580576 = path.getOrDefault("parent")
  valid_580576 = validateParameter(valid_580576, JString, required = true,
                                 default = nil)
  if valid_580576 != nil:
    section.add "parent", valid_580576
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
  var valid_580577 = query.getOrDefault("upload_protocol")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "upload_protocol", valid_580577
  var valid_580578 = query.getOrDefault("fields")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "fields", valid_580578
  var valid_580579 = query.getOrDefault("quotaUser")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "quotaUser", valid_580579
  var valid_580580 = query.getOrDefault("alt")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = newJString("json"))
  if valid_580580 != nil:
    section.add "alt", valid_580580
  var valid_580581 = query.getOrDefault("oauth_token")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "oauth_token", valid_580581
  var valid_580582 = query.getOrDefault("callback")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "callback", valid_580582
  var valid_580583 = query.getOrDefault("access_token")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "access_token", valid_580583
  var valid_580584 = query.getOrDefault("uploadType")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "uploadType", valid_580584
  var valid_580585 = query.getOrDefault("hl7V2StoreId")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "hl7V2StoreId", valid_580585
  var valid_580586 = query.getOrDefault("key")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "key", valid_580586
  var valid_580587 = query.getOrDefault("$.xgafv")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = newJString("1"))
  if valid_580587 != nil:
    section.add "$.xgafv", valid_580587
  var valid_580588 = query.getOrDefault("prettyPrint")
  valid_580588 = validateParameter(valid_580588, JBool, required = false,
                                 default = newJBool(true))
  if valid_580588 != nil:
    section.add "prettyPrint", valid_580588
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

proc call*(call_580590: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580573;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new HL7v2 store within the parent dataset.
  ## 
  let valid = call_580590.validator(path, query, header, formData, body)
  let scheme = call_580590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580590.url(scheme.get, call_580590.host, call_580590.base,
                         call_580590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580590, url, valid)

proc call*(call_580591: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580573;
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
  var path_580592 = newJObject()
  var query_580593 = newJObject()
  var body_580594 = newJObject()
  add(query_580593, "upload_protocol", newJString(uploadProtocol))
  add(query_580593, "fields", newJString(fields))
  add(query_580593, "quotaUser", newJString(quotaUser))
  add(query_580593, "alt", newJString(alt))
  add(query_580593, "oauth_token", newJString(oauthToken))
  add(query_580593, "callback", newJString(callback))
  add(query_580593, "access_token", newJString(accessToken))
  add(query_580593, "uploadType", newJString(uploadType))
  add(path_580592, "parent", newJString(parent))
  add(query_580593, "hl7V2StoreId", newJString(hl7V2StoreId))
  add(query_580593, "key", newJString(key))
  add(query_580593, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580594 = body
  add(query_580593, "prettyPrint", newJBool(prettyPrint))
  result = call_580591.call(path_580592, query_580593, nil, nil, body_580594)

var healthcareProjectsLocationsDatasetsHl7V2StoresCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580573(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580574,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_580575,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580551 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580553(
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
               (kind: ConstantSegment, value: "/hl7V2Stores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580552(
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
  var valid_580554 = path.getOrDefault("parent")
  valid_580554 = validateParameter(valid_580554, JString, required = true,
                                 default = nil)
  if valid_580554 != nil:
    section.add "parent", valid_580554
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
  ## Only filtering on labels is supported. For example, `labels.key=value`.
  section = newJObject()
  var valid_580555 = query.getOrDefault("upload_protocol")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "upload_protocol", valid_580555
  var valid_580556 = query.getOrDefault("fields")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "fields", valid_580556
  var valid_580557 = query.getOrDefault("pageToken")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "pageToken", valid_580557
  var valid_580558 = query.getOrDefault("quotaUser")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "quotaUser", valid_580558
  var valid_580559 = query.getOrDefault("alt")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = newJString("json"))
  if valid_580559 != nil:
    section.add "alt", valid_580559
  var valid_580560 = query.getOrDefault("oauth_token")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "oauth_token", valid_580560
  var valid_580561 = query.getOrDefault("callback")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "callback", valid_580561
  var valid_580562 = query.getOrDefault("access_token")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "access_token", valid_580562
  var valid_580563 = query.getOrDefault("uploadType")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "uploadType", valid_580563
  var valid_580564 = query.getOrDefault("key")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "key", valid_580564
  var valid_580565 = query.getOrDefault("$.xgafv")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = newJString("1"))
  if valid_580565 != nil:
    section.add "$.xgafv", valid_580565
  var valid_580566 = query.getOrDefault("pageSize")
  valid_580566 = validateParameter(valid_580566, JInt, required = false, default = nil)
  if valid_580566 != nil:
    section.add "pageSize", valid_580566
  var valid_580567 = query.getOrDefault("prettyPrint")
  valid_580567 = validateParameter(valid_580567, JBool, required = false,
                                 default = newJBool(true))
  if valid_580567 != nil:
    section.add "prettyPrint", valid_580567
  var valid_580568 = query.getOrDefault("filter")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "filter", valid_580568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580569: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the HL7v2 stores in the given dataset.
  ## 
  let valid = call_580569.validator(path, query, header, formData, body)
  let scheme = call_580569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580569.url(scheme.get, call_580569.host, call_580569.base,
                         call_580569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580569, url, valid)

proc call*(call_580570: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580551;
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
  ## Only filtering on labels is supported. For example, `labels.key=value`.
  var path_580571 = newJObject()
  var query_580572 = newJObject()
  add(query_580572, "upload_protocol", newJString(uploadProtocol))
  add(query_580572, "fields", newJString(fields))
  add(query_580572, "pageToken", newJString(pageToken))
  add(query_580572, "quotaUser", newJString(quotaUser))
  add(query_580572, "alt", newJString(alt))
  add(query_580572, "oauth_token", newJString(oauthToken))
  add(query_580572, "callback", newJString(callback))
  add(query_580572, "access_token", newJString(accessToken))
  add(query_580572, "uploadType", newJString(uploadType))
  add(path_580571, "parent", newJString(parent))
  add(query_580572, "key", newJString(key))
  add(query_580572, "$.xgafv", newJString(Xgafv))
  add(query_580572, "pageSize", newJInt(pageSize))
  add(query_580572, "prettyPrint", newJBool(prettyPrint))
  add(query_580572, "filter", newJString(filter))
  result = call_580570.call(path_580571, query_580572, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580551(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580552,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_580553,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580618 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580620(
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
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580619(
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
  var valid_580621 = path.getOrDefault("parent")
  valid_580621 = validateParameter(valid_580621, JString, required = true,
                                 default = nil)
  if valid_580621 != nil:
    section.add "parent", valid_580621
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
  var valid_580622 = query.getOrDefault("upload_protocol")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "upload_protocol", valid_580622
  var valid_580623 = query.getOrDefault("fields")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "fields", valid_580623
  var valid_580624 = query.getOrDefault("quotaUser")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "quotaUser", valid_580624
  var valid_580625 = query.getOrDefault("alt")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = newJString("json"))
  if valid_580625 != nil:
    section.add "alt", valid_580625
  var valid_580626 = query.getOrDefault("oauth_token")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "oauth_token", valid_580626
  var valid_580627 = query.getOrDefault("callback")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "callback", valid_580627
  var valid_580628 = query.getOrDefault("access_token")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "access_token", valid_580628
  var valid_580629 = query.getOrDefault("uploadType")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "uploadType", valid_580629
  var valid_580630 = query.getOrDefault("key")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "key", valid_580630
  var valid_580631 = query.getOrDefault("$.xgafv")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = newJString("1"))
  if valid_580631 != nil:
    section.add "$.xgafv", valid_580631
  var valid_580632 = query.getOrDefault("prettyPrint")
  valid_580632 = validateParameter(valid_580632, JBool, required = false,
                                 default = newJBool(true))
  if valid_580632 != nil:
    section.add "prettyPrint", valid_580632
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

proc call*(call_580634: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580618;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a message and sends a notification to the Cloud Pub/Sub topic. If
  ## configured, the MLLP adapter listens to messages created by this method and
  ## sends those back to the hospital. A successful response indicates the
  ## message has been persisted to storage and a Cloud Pub/Sub notification has
  ## been sent. Sending to the hospital by the MLLP adapter happens
  ## asynchronously.
  ## 
  let valid = call_580634.validator(path, query, header, formData, body)
  let scheme = call_580634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580634.url(scheme.get, call_580634.host, call_580634.base,
                         call_580634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580634, url, valid)

proc call*(call_580635: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580618;
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
  var path_580636 = newJObject()
  var query_580637 = newJObject()
  var body_580638 = newJObject()
  add(query_580637, "upload_protocol", newJString(uploadProtocol))
  add(query_580637, "fields", newJString(fields))
  add(query_580637, "quotaUser", newJString(quotaUser))
  add(query_580637, "alt", newJString(alt))
  add(query_580637, "oauth_token", newJString(oauthToken))
  add(query_580637, "callback", newJString(callback))
  add(query_580637, "access_token", newJString(accessToken))
  add(query_580637, "uploadType", newJString(uploadType))
  add(path_580636, "parent", newJString(parent))
  add(query_580637, "key", newJString(key))
  add(query_580637, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580638 = body
  add(query_580637, "prettyPrint", newJBool(prettyPrint))
  result = call_580635.call(path_580636, query_580637, nil, nil, body_580638)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580618(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580619,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_580620,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580595 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580597(
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
               (kind: ConstantSegment, value: "/messages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580596(
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
  var valid_580598 = path.getOrDefault("parent")
  valid_580598 = validateParameter(valid_580598, JString, required = true,
                                 default = nil)
  if valid_580598 != nil:
    section.add "parent", valid_580598
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
  ## *  `message_type`, from the MSH-9 segment. For example,
  ## `NOT message_type = "ADT"`.
  ## *  `send_date` or `sendDate`, the YYYY-MM-DD date the message was sent in
  ## the dataset's time_zone, from the MSH-7 segment. For example,
  ## `send_date < "2017-01-02"`.
  ## *  `send_time`, the timestamp when the message was sent, using the
  ## RFC3339 time format for comparisons, from the MSH-7 segment. For example,
  ## `send_time < "2017-01-02T00:00:00-05:00"`.
  ## *  `send_facility`, the care center that the message came from, from the
  ## MSH-4 segment. For example, `send_facility = "ABC"`.
  ## *  `HL7RegExp(expr)`, which does regular expression matching of `expr`
  ## against the message payload using RE2 syntax
  ## (https://github.com/google/re2/wiki/Syntax). For example,
  ## `HL7RegExp("^.*\|.*\|EMERG")`.
  ## *  `PatientId(value, type)`, which matches if the message lists a patient
  ## having an ID of the given value and type in the PID-2, PID-3, or PID-4
  ## segments. For example, `PatientId("123456", "MRN")`.
  ## *  `labels.x`, a string value of the label with key `x` as set using the
  ## Message.labels
  ## map. For example, `labels."priority"="high"`. The operator `:*` can be used
  ## to assert the existence of a label. For example, `labels."priority":*`.
  ## 
  ## Limitations on conjunctions:
  ## 
  ## *  Negation on the patient ID function or the labels field is not
  ## supported. For example, these queries are invalid:
  ## `NOT PatientId("123456", "MRN")`, `NOT labels."tag1":*`,
  ## `NOT labels."tag2"="val2"`.
  ## *  Conjunction of multiple patient ID functions is not supported, for
  ## example this query is invalid:
  ## `PatientId("123456", "MRN") AND PatientId("456789", "MRN")`.
  ## *  Conjunction of multiple labels fields is also not supported, for
  ## example this query is invalid: `labels."tag1":* AND labels."tag2"="val2"`.
  ## *  Conjunction of one patient ID function, one labels field and conditions
  ## on other fields is supported. For example, this query is valid:
  ## `PatientId("123456", "MRN") AND labels."tag1":* AND message_type = "ADT"`.
  section = newJObject()
  var valid_580599 = query.getOrDefault("upload_protocol")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "upload_protocol", valid_580599
  var valid_580600 = query.getOrDefault("fields")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "fields", valid_580600
  var valid_580601 = query.getOrDefault("pageToken")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "pageToken", valid_580601
  var valid_580602 = query.getOrDefault("quotaUser")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = nil)
  if valid_580602 != nil:
    section.add "quotaUser", valid_580602
  var valid_580603 = query.getOrDefault("alt")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = newJString("json"))
  if valid_580603 != nil:
    section.add "alt", valid_580603
  var valid_580604 = query.getOrDefault("oauth_token")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "oauth_token", valid_580604
  var valid_580605 = query.getOrDefault("callback")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "callback", valid_580605
  var valid_580606 = query.getOrDefault("access_token")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "access_token", valid_580606
  var valid_580607 = query.getOrDefault("uploadType")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "uploadType", valid_580607
  var valid_580608 = query.getOrDefault("orderBy")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "orderBy", valid_580608
  var valid_580609 = query.getOrDefault("key")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "key", valid_580609
  var valid_580610 = query.getOrDefault("$.xgafv")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = newJString("1"))
  if valid_580610 != nil:
    section.add "$.xgafv", valid_580610
  var valid_580611 = query.getOrDefault("pageSize")
  valid_580611 = validateParameter(valid_580611, JInt, required = false, default = nil)
  if valid_580611 != nil:
    section.add "pageSize", valid_580611
  var valid_580612 = query.getOrDefault("prettyPrint")
  valid_580612 = validateParameter(valid_580612, JBool, required = false,
                                 default = newJBool(true))
  if valid_580612 != nil:
    section.add "prettyPrint", valid_580612
  var valid_580613 = query.getOrDefault("filter")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "filter", valid_580613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580614: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580595;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the messages in the given HL7v2 store with support for filtering.
  ## 
  ## Note: HL7v2 messages are indexed asynchronously, so there might be a slight
  ## delay between the time a message is created and when it can be found
  ## through a filter.
  ## 
  let valid = call_580614.validator(path, query, header, formData, body)
  let scheme = call_580614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580614.url(scheme.get, call_580614.host, call_580614.base,
                         call_580614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580614, url, valid)

proc call*(call_580615: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580595;
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
  ## *  `message_type`, from the MSH-9 segment. For example,
  ## `NOT message_type = "ADT"`.
  ## *  `send_date` or `sendDate`, the YYYY-MM-DD date the message was sent in
  ## the dataset's time_zone, from the MSH-7 segment. For example,
  ## `send_date < "2017-01-02"`.
  ## *  `send_time`, the timestamp when the message was sent, using the
  ## RFC3339 time format for comparisons, from the MSH-7 segment. For example,
  ## `send_time < "2017-01-02T00:00:00-05:00"`.
  ## *  `send_facility`, the care center that the message came from, from the
  ## MSH-4 segment. For example, `send_facility = "ABC"`.
  ## *  `HL7RegExp(expr)`, which does regular expression matching of `expr`
  ## against the message payload using RE2 syntax
  ## (https://github.com/google/re2/wiki/Syntax). For example,
  ## `HL7RegExp("^.*\|.*\|EMERG")`.
  ## *  `PatientId(value, type)`, which matches if the message lists a patient
  ## having an ID of the given value and type in the PID-2, PID-3, or PID-4
  ## segments. For example, `PatientId("123456", "MRN")`.
  ## *  `labels.x`, a string value of the label with key `x` as set using the
  ## Message.labels
  ## map. For example, `labels."priority"="high"`. The operator `:*` can be used
  ## to assert the existence of a label. For example, `labels."priority":*`.
  ## 
  ## Limitations on conjunctions:
  ## 
  ## *  Negation on the patient ID function or the labels field is not
  ## supported. For example, these queries are invalid:
  ## `NOT PatientId("123456", "MRN")`, `NOT labels."tag1":*`,
  ## `NOT labels."tag2"="val2"`.
  ## *  Conjunction of multiple patient ID functions is not supported, for
  ## example this query is invalid:
  ## `PatientId("123456", "MRN") AND PatientId("456789", "MRN")`.
  ## *  Conjunction of multiple labels fields is also not supported, for
  ## example this query is invalid: `labels."tag1":* AND labels."tag2"="val2"`.
  ## *  Conjunction of one patient ID function, one labels field and conditions
  ## on other fields is supported. For example, this query is valid:
  ## `PatientId("123456", "MRN") AND labels."tag1":* AND message_type = "ADT"`.
  var path_580616 = newJObject()
  var query_580617 = newJObject()
  add(query_580617, "upload_protocol", newJString(uploadProtocol))
  add(query_580617, "fields", newJString(fields))
  add(query_580617, "pageToken", newJString(pageToken))
  add(query_580617, "quotaUser", newJString(quotaUser))
  add(query_580617, "alt", newJString(alt))
  add(query_580617, "oauth_token", newJString(oauthToken))
  add(query_580617, "callback", newJString(callback))
  add(query_580617, "access_token", newJString(accessToken))
  add(query_580617, "uploadType", newJString(uploadType))
  add(path_580616, "parent", newJString(parent))
  add(query_580617, "orderBy", newJString(orderBy))
  add(query_580617, "key", newJString(key))
  add(query_580617, "$.xgafv", newJString(Xgafv))
  add(query_580617, "pageSize", newJInt(pageSize))
  add(query_580617, "prettyPrint", newJBool(prettyPrint))
  add(query_580617, "filter", newJString(filter))
  result = call_580615.call(path_580616, query_580617, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580595(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580596,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_580597,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580639 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580641(
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
               (kind: ConstantSegment, value: "/messages:ingest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580640(
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
  var valid_580642 = path.getOrDefault("parent")
  valid_580642 = validateParameter(valid_580642, JString, required = true,
                                 default = nil)
  if valid_580642 != nil:
    section.add "parent", valid_580642
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
  var valid_580643 = query.getOrDefault("upload_protocol")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "upload_protocol", valid_580643
  var valid_580644 = query.getOrDefault("fields")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "fields", valid_580644
  var valid_580645 = query.getOrDefault("quotaUser")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "quotaUser", valid_580645
  var valid_580646 = query.getOrDefault("alt")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = newJString("json"))
  if valid_580646 != nil:
    section.add "alt", valid_580646
  var valid_580647 = query.getOrDefault("oauth_token")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "oauth_token", valid_580647
  var valid_580648 = query.getOrDefault("callback")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "callback", valid_580648
  var valid_580649 = query.getOrDefault("access_token")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "access_token", valid_580649
  var valid_580650 = query.getOrDefault("uploadType")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "uploadType", valid_580650
  var valid_580651 = query.getOrDefault("key")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "key", valid_580651
  var valid_580652 = query.getOrDefault("$.xgafv")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = newJString("1"))
  if valid_580652 != nil:
    section.add "$.xgafv", valid_580652
  var valid_580653 = query.getOrDefault("prettyPrint")
  valid_580653 = validateParameter(valid_580653, JBool, required = false,
                                 default = newJBool(true))
  if valid_580653 != nil:
    section.add "prettyPrint", valid_580653
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

proc call*(call_580655: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580639;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Ingests a new HL7v2 message from the hospital and sends a notification to
  ## the Cloud Pub/Sub topic. Return is an HL7v2 ACK message if the message was
  ## successfully stored. Otherwise an error is returned.  If an identical
  ## HL7v2 message is created twice only one resource is created on the server
  ## and no error is reported.
  ## 
  let valid = call_580655.validator(path, query, header, formData, body)
  let scheme = call_580655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580655.url(scheme.get, call_580655.host, call_580655.base,
                         call_580655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580655, url, valid)

proc call*(call_580656: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580639;
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
  var path_580657 = newJObject()
  var query_580658 = newJObject()
  var body_580659 = newJObject()
  add(query_580658, "upload_protocol", newJString(uploadProtocol))
  add(query_580658, "fields", newJString(fields))
  add(query_580658, "quotaUser", newJString(quotaUser))
  add(query_580658, "alt", newJString(alt))
  add(query_580658, "oauth_token", newJString(oauthToken))
  add(query_580658, "callback", newJString(callback))
  add(query_580658, "access_token", newJString(accessToken))
  add(query_580658, "uploadType", newJString(uploadType))
  add(path_580657, "parent", newJString(parent))
  add(query_580658, "key", newJString(key))
  add(query_580658, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580659 = body
  add(query_580658, "prettyPrint", newJBool(prettyPrint))
  result = call_580656.call(path_580657, query_580658, nil, nil, body_580659)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580639(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/messages:ingest", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580640,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_580641,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_580660 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_580662(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_580661(
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
  var valid_580663 = path.getOrDefault("resource")
  valid_580663 = validateParameter(valid_580663, JString, required = true,
                                 default = nil)
  if valid_580663 != nil:
    section.add "resource", valid_580663
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
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580664 = query.getOrDefault("upload_protocol")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "upload_protocol", valid_580664
  var valid_580665 = query.getOrDefault("fields")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "fields", valid_580665
  var valid_580666 = query.getOrDefault("quotaUser")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "quotaUser", valid_580666
  var valid_580667 = query.getOrDefault("alt")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = newJString("json"))
  if valid_580667 != nil:
    section.add "alt", valid_580667
  var valid_580668 = query.getOrDefault("oauth_token")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "oauth_token", valid_580668
  var valid_580669 = query.getOrDefault("callback")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "callback", valid_580669
  var valid_580670 = query.getOrDefault("access_token")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "access_token", valid_580670
  var valid_580671 = query.getOrDefault("uploadType")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "uploadType", valid_580671
  var valid_580672 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580672 = validateParameter(valid_580672, JInt, required = false, default = nil)
  if valid_580672 != nil:
    section.add "options.requestedPolicyVersion", valid_580672
  var valid_580673 = query.getOrDefault("key")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "key", valid_580673
  var valid_580674 = query.getOrDefault("$.xgafv")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = newJString("1"))
  if valid_580674 != nil:
    section.add "$.xgafv", valid_580674
  var valid_580675 = query.getOrDefault("prettyPrint")
  valid_580675 = validateParameter(valid_580675, JBool, required = false,
                                 default = newJBool(true))
  if valid_580675 != nil:
    section.add "prettyPrint", valid_580675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580676: Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_580660;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580676.validator(path, query, header, formData, body)
  let scheme = call_580676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580676.url(scheme.get, call_580676.host, call_580676.base,
                         call_580676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580676, url, valid)

proc call*(call_580677: Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_580660;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy
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
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580678 = newJObject()
  var query_580679 = newJObject()
  add(query_580679, "upload_protocol", newJString(uploadProtocol))
  add(query_580679, "fields", newJString(fields))
  add(query_580679, "quotaUser", newJString(quotaUser))
  add(query_580679, "alt", newJString(alt))
  add(query_580679, "oauth_token", newJString(oauthToken))
  add(query_580679, "callback", newJString(callback))
  add(query_580679, "access_token", newJString(accessToken))
  add(query_580679, "uploadType", newJString(uploadType))
  add(query_580679, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580679, "key", newJString(key))
  add(query_580679, "$.xgafv", newJString(Xgafv))
  add(path_580678, "resource", newJString(resource))
  add(query_580679, "prettyPrint", newJBool(prettyPrint))
  result = call_580677.call(path_580678, query_580679, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_580660(
    name: "healthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_580661,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_580662,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_580680 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_580682(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_580681(
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
  var valid_580683 = path.getOrDefault("resource")
  valid_580683 = validateParameter(valid_580683, JString, required = true,
                                 default = nil)
  if valid_580683 != nil:
    section.add "resource", valid_580683
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
  var valid_580684 = query.getOrDefault("upload_protocol")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "upload_protocol", valid_580684
  var valid_580685 = query.getOrDefault("fields")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "fields", valid_580685
  var valid_580686 = query.getOrDefault("quotaUser")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "quotaUser", valid_580686
  var valid_580687 = query.getOrDefault("alt")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = newJString("json"))
  if valid_580687 != nil:
    section.add "alt", valid_580687
  var valid_580688 = query.getOrDefault("oauth_token")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "oauth_token", valid_580688
  var valid_580689 = query.getOrDefault("callback")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "callback", valid_580689
  var valid_580690 = query.getOrDefault("access_token")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "access_token", valid_580690
  var valid_580691 = query.getOrDefault("uploadType")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "uploadType", valid_580691
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

proc call*(call_580696: Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_580680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580696.validator(path, query, header, formData, body)
  let scheme = call_580696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580696.url(scheme.get, call_580696.host, call_580696.base,
                         call_580696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580696, url, valid)

proc call*(call_580697: Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_580680;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy
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
  add(query_580699, "key", newJString(key))
  add(query_580699, "$.xgafv", newJString(Xgafv))
  add(path_580698, "resource", newJString(resource))
  if body != nil:
    body_580700 = body
  add(query_580699, "prettyPrint", newJBool(prettyPrint))
  result = call_580697.call(path_580698, query_580699, nil, nil, body_580700)

var healthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_580680(
    name: "healthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_580681,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_580682,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_580701 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_580703(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_580702(
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
  var valid_580704 = path.getOrDefault("resource")
  valid_580704 = validateParameter(valid_580704, JString, required = true,
                                 default = nil)
  if valid_580704 != nil:
    section.add "resource", valid_580704
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
  var valid_580707 = query.getOrDefault("quotaUser")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "quotaUser", valid_580707
  var valid_580708 = query.getOrDefault("alt")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = newJString("json"))
  if valid_580708 != nil:
    section.add "alt", valid_580708
  var valid_580709 = query.getOrDefault("oauth_token")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "oauth_token", valid_580709
  var valid_580710 = query.getOrDefault("callback")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "callback", valid_580710
  var valid_580711 = query.getOrDefault("access_token")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "access_token", valid_580711
  var valid_580712 = query.getOrDefault("uploadType")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "uploadType", valid_580712
  var valid_580713 = query.getOrDefault("key")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "key", valid_580713
  var valid_580714 = query.getOrDefault("$.xgafv")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = newJString("1"))
  if valid_580714 != nil:
    section.add "$.xgafv", valid_580714
  var valid_580715 = query.getOrDefault("prettyPrint")
  valid_580715 = validateParameter(valid_580715, JBool, required = false,
                                 default = newJBool(true))
  if valid_580715 != nil:
    section.add "prettyPrint", valid_580715
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

proc call*(call_580717: Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_580701;
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
  let valid = call_580717.validator(path, query, header, formData, body)
  let scheme = call_580717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580717.url(scheme.get, call_580717.host, call_580717.base,
                         call_580717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580717, url, valid)

proc call*(call_580718: Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_580701;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions
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
  var path_580719 = newJObject()
  var query_580720 = newJObject()
  var body_580721 = newJObject()
  add(query_580720, "upload_protocol", newJString(uploadProtocol))
  add(query_580720, "fields", newJString(fields))
  add(query_580720, "quotaUser", newJString(quotaUser))
  add(query_580720, "alt", newJString(alt))
  add(query_580720, "oauth_token", newJString(oauthToken))
  add(query_580720, "callback", newJString(callback))
  add(query_580720, "access_token", newJString(accessToken))
  add(query_580720, "uploadType", newJString(uploadType))
  add(query_580720, "key", newJString(key))
  add(query_580720, "$.xgafv", newJString(Xgafv))
  add(path_580719, "resource", newJString(resource))
  if body != nil:
    body_580721 = body
  add(query_580720, "prettyPrint", newJBool(prettyPrint))
  result = call_580718.call(path_580719, query_580720, nil, nil, body_580721)

var healthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions* = Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_580701(
    name: "healthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_580702,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_580703,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDeidentify_580722 = ref object of OpenApiRestCall_579421
proc url_HealthcareProjectsLocationsDatasetsDeidentify_580724(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceDataset" in path, "`sourceDataset` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "sourceDataset"),
               (kind: ConstantSegment, value: ":deidentify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HealthcareProjectsLocationsDatasetsDeidentify_580723(
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
  ## Errors are also logged to Stackdriver Logging. For more information,
  ## see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceDataset: JString (required)
  ##                : Source dataset resource name. For example,
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sourceDataset` field"
  var valid_580725 = path.getOrDefault("sourceDataset")
  valid_580725 = validateParameter(valid_580725, JString, required = true,
                                 default = nil)
  if valid_580725 != nil:
    section.add "sourceDataset", valid_580725
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
  var valid_580726 = query.getOrDefault("upload_protocol")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "upload_protocol", valid_580726
  var valid_580727 = query.getOrDefault("fields")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "fields", valid_580727
  var valid_580728 = query.getOrDefault("quotaUser")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "quotaUser", valid_580728
  var valid_580729 = query.getOrDefault("alt")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = newJString("json"))
  if valid_580729 != nil:
    section.add "alt", valid_580729
  var valid_580730 = query.getOrDefault("oauth_token")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "oauth_token", valid_580730
  var valid_580731 = query.getOrDefault("callback")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "callback", valid_580731
  var valid_580732 = query.getOrDefault("access_token")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "access_token", valid_580732
  var valid_580733 = query.getOrDefault("uploadType")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "uploadType", valid_580733
  var valid_580734 = query.getOrDefault("key")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "key", valid_580734
  var valid_580735 = query.getOrDefault("$.xgafv")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = newJString("1"))
  if valid_580735 != nil:
    section.add "$.xgafv", valid_580735
  var valid_580736 = query.getOrDefault("prettyPrint")
  valid_580736 = validateParameter(valid_580736, JBool, required = false,
                                 default = newJBool(true))
  if valid_580736 != nil:
    section.add "prettyPrint", valid_580736
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

proc call*(call_580738: Call_HealthcareProjectsLocationsDatasetsDeidentify_580722;
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
  ## Errors are also logged to Stackdriver Logging. For more information,
  ## see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging).
  ## 
  let valid = call_580738.validator(path, query, header, formData, body)
  let scheme = call_580738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580738.url(scheme.get, call_580738.host, call_580738.base,
                         call_580738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580738, url, valid)

proc call*(call_580739: Call_HealthcareProjectsLocationsDatasetsDeidentify_580722;
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
  ## Errors are also logged to Stackdriver Logging. For more information,
  ## see [Viewing logs](/healthcare/docs/how-tos/stackdriver-logging).
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
  ##                : Source dataset resource name. For example,
  ## `projects/{project_id}/locations/{location_id}/datasets/{dataset_id}`.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580740 = newJObject()
  var query_580741 = newJObject()
  var body_580742 = newJObject()
  add(query_580741, "upload_protocol", newJString(uploadProtocol))
  add(query_580741, "fields", newJString(fields))
  add(query_580741, "quotaUser", newJString(quotaUser))
  add(query_580741, "alt", newJString(alt))
  add(query_580741, "oauth_token", newJString(oauthToken))
  add(query_580741, "callback", newJString(callback))
  add(query_580741, "access_token", newJString(accessToken))
  add(query_580741, "uploadType", newJString(uploadType))
  add(query_580741, "key", newJString(key))
  add(query_580741, "$.xgafv", newJString(Xgafv))
  add(path_580740, "sourceDataset", newJString(sourceDataset))
  if body != nil:
    body_580742 = body
  add(query_580741, "prettyPrint", newJBool(prettyPrint))
  result = call_580739.call(path_580740, query_580741, nil, nil, body_580742)

var healthcareProjectsLocationsDatasetsDeidentify* = Call_HealthcareProjectsLocationsDatasetsDeidentify_580722(
    name: "healthcareProjectsLocationsDatasetsDeidentify",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{sourceDataset}:deidentify",
    validator: validate_HealthcareProjectsLocationsDatasetsDeidentify_580723,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDeidentify_580724,
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
