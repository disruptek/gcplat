
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "healthcare"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_589008 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_589010(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_589009(
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
  var valid_589011 = path.getOrDefault("name")
  valid_589011 = validateParameter(valid_589011, JString, required = true,
                                 default = nil)
  if valid_589011 != nil:
    section.add "name", valid_589011
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
  var valid_589012 = query.getOrDefault("upload_protocol")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "upload_protocol", valid_589012
  var valid_589013 = query.getOrDefault("fields")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "fields", valid_589013
  var valid_589014 = query.getOrDefault("quotaUser")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "quotaUser", valid_589014
  var valid_589015 = query.getOrDefault("alt")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("json"))
  if valid_589015 != nil:
    section.add "alt", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("callback")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "callback", valid_589017
  var valid_589018 = query.getOrDefault("access_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "access_token", valid_589018
  var valid_589019 = query.getOrDefault("uploadType")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "uploadType", valid_589019
  var valid_589020 = query.getOrDefault("key")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "key", valid_589020
  var valid_589021 = query.getOrDefault("$.xgafv")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = newJString("1"))
  if valid_589021 != nil:
    section.add "$.xgafv", valid_589021
  var valid_589022 = query.getOrDefault("prettyPrint")
  valid_589022 = validateParameter(valid_589022, JBool, required = false,
                                 default = newJBool(true))
  if valid_589022 != nil:
    section.add "prettyPrint", valid_589022
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

proc call*(call_589024: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_589008;
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
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_589008;
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
  var path_589026 = newJObject()
  var query_589027 = newJObject()
  var body_589028 = newJObject()
  add(query_589027, "upload_protocol", newJString(uploadProtocol))
  add(query_589027, "fields", newJString(fields))
  add(query_589027, "quotaUser", newJString(quotaUser))
  add(path_589026, "name", newJString(name))
  add(query_589027, "alt", newJString(alt))
  add(query_589027, "oauth_token", newJString(oauthToken))
  add(query_589027, "callback", newJString(callback))
  add(query_589027, "access_token", newJString(accessToken))
  add(query_589027, "uploadType", newJString(uploadType))
  add(query_589027, "key", newJString(key))
  add(query_589027, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589028 = body
  add(query_589027, "prettyPrint", newJBool(prettyPrint))
  result = call_589025.call(path_589026, query_589027, nil, nil, body_589028)

var healthcareProjectsLocationsDatasetsFhirStoresFhirUpdate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_589008(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirUpdate",
    meth: HttpMethod.HttpPut, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_589009,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirUpdate_589010,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_588719 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_588721(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_588720(
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
  var valid_588847 = path.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
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
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588863 = query.getOrDefault("view")
  valid_588863 = validateParameter(valid_588863, JString, required = false, default = newJString(
      "MESSAGE_VIEW_UNSPECIFIED"))
  if valid_588863 != nil:
    section.add "view", valid_588863
  var valid_588864 = query.getOrDefault("quotaUser")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "quotaUser", valid_588864
  var valid_588865 = query.getOrDefault("alt")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = newJString("json"))
  if valid_588865 != nil:
    section.add "alt", valid_588865
  var valid_588866 = query.getOrDefault("oauth_token")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "oauth_token", valid_588866
  var valid_588867 = query.getOrDefault("callback")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "callback", valid_588867
  var valid_588868 = query.getOrDefault("access_token")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "access_token", valid_588868
  var valid_588869 = query.getOrDefault("uploadType")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "uploadType", valid_588869
  var valid_588870 = query.getOrDefault("key")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "key", valid_588870
  var valid_588871 = query.getOrDefault("$.xgafv")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = newJString("1"))
  if valid_588871 != nil:
    section.add "$.xgafv", valid_588871
  var valid_588872 = query.getOrDefault("prettyPrint")
  valid_588872 = validateParameter(valid_588872, JBool, required = false,
                                 default = newJBool(true))
  if valid_588872 != nil:
    section.add "prettyPrint", valid_588872
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588895: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_588719;
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
  let valid = call_588895.validator(path, query, header, formData, body)
  let scheme = call_588895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588895.url(scheme.get, call_588895.host, call_588895.base,
                         call_588895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588895, url, valid)

proc call*(call_588966: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_588719;
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
  var path_588967 = newJObject()
  var query_588969 = newJObject()
  add(query_588969, "upload_protocol", newJString(uploadProtocol))
  add(query_588969, "fields", newJString(fields))
  add(query_588969, "view", newJString(view))
  add(query_588969, "quotaUser", newJString(quotaUser))
  add(path_588967, "name", newJString(name))
  add(query_588969, "alt", newJString(alt))
  add(query_588969, "oauth_token", newJString(oauthToken))
  add(query_588969, "callback", newJString(callback))
  add(query_588969, "access_token", newJString(accessToken))
  add(query_588969, "uploadType", newJString(uploadType))
  add(query_588969, "key", newJString(key))
  add(query_588969, "$.xgafv", newJString(Xgafv))
  add(query_588969, "prettyPrint", newJBool(prettyPrint))
  result = call_588966.call(path_588967, query_588969, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirRead* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_588719(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirRead",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_588720,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirRead_588721,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_589048 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_589050(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_589049(
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
  var valid_589051 = path.getOrDefault("name")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "name", valid_589051
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
  var valid_589052 = query.getOrDefault("upload_protocol")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "upload_protocol", valid_589052
  var valid_589053 = query.getOrDefault("fields")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "fields", valid_589053
  var valid_589054 = query.getOrDefault("quotaUser")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "quotaUser", valid_589054
  var valid_589055 = query.getOrDefault("alt")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("json"))
  if valid_589055 != nil:
    section.add "alt", valid_589055
  var valid_589056 = query.getOrDefault("oauth_token")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "oauth_token", valid_589056
  var valid_589057 = query.getOrDefault("callback")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "callback", valid_589057
  var valid_589058 = query.getOrDefault("access_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "access_token", valid_589058
  var valid_589059 = query.getOrDefault("uploadType")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "uploadType", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("$.xgafv")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = newJString("1"))
  if valid_589061 != nil:
    section.add "$.xgafv", valid_589061
  var valid_589062 = query.getOrDefault("prettyPrint")
  valid_589062 = validateParameter(valid_589062, JBool, required = false,
                                 default = newJBool(true))
  if valid_589062 != nil:
    section.add "prettyPrint", valid_589062
  var valid_589063 = query.getOrDefault("updateMask")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "updateMask", valid_589063
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

proc call*(call_589065: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_589048;
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
  let valid = call_589065.validator(path, query, header, formData, body)
  let scheme = call_589065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589065.url(scheme.get, call_589065.host, call_589065.base,
                         call_589065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589065, url, valid)

proc call*(call_589066: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_589048;
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
  var path_589067 = newJObject()
  var query_589068 = newJObject()
  var body_589069 = newJObject()
  add(query_589068, "upload_protocol", newJString(uploadProtocol))
  add(query_589068, "fields", newJString(fields))
  add(query_589068, "quotaUser", newJString(quotaUser))
  add(path_589067, "name", newJString(name))
  add(query_589068, "alt", newJString(alt))
  add(query_589068, "oauth_token", newJString(oauthToken))
  add(query_589068, "callback", newJString(callback))
  add(query_589068, "access_token", newJString(accessToken))
  add(query_589068, "uploadType", newJString(uploadType))
  add(query_589068, "key", newJString(key))
  add(query_589068, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589069 = body
  add(query_589068, "prettyPrint", newJBool(prettyPrint))
  add(query_589068, "updateMask", newJString(updateMask))
  result = call_589066.call(path_589067, query_589068, nil, nil, body_589069)

var healthcareProjectsLocationsDatasetsFhirStoresFhirPatch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_589048(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_589049,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatch_589050,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_589029 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_589031(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_589030(
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
  var valid_589032 = path.getOrDefault("name")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "name", valid_589032
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
  var valid_589033 = query.getOrDefault("upload_protocol")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "upload_protocol", valid_589033
  var valid_589034 = query.getOrDefault("fields")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "fields", valid_589034
  var valid_589035 = query.getOrDefault("quotaUser")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "quotaUser", valid_589035
  var valid_589036 = query.getOrDefault("alt")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("json"))
  if valid_589036 != nil:
    section.add "alt", valid_589036
  var valid_589037 = query.getOrDefault("oauth_token")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "oauth_token", valid_589037
  var valid_589038 = query.getOrDefault("callback")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "callback", valid_589038
  var valid_589039 = query.getOrDefault("access_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "access_token", valid_589039
  var valid_589040 = query.getOrDefault("uploadType")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "uploadType", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("$.xgafv")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("1"))
  if valid_589042 != nil:
    section.add "$.xgafv", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589044: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_589029;
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
  let valid = call_589044.validator(path, query, header, formData, body)
  let scheme = call_589044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589044.url(scheme.get, call_589044.host, call_589044.base,
                         call_589044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589044, url, valid)

proc call*(call_589045: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_589029;
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
  var path_589046 = newJObject()
  var query_589047 = newJObject()
  add(query_589047, "upload_protocol", newJString(uploadProtocol))
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(path_589046, "name", newJString(name))
  add(query_589047, "alt", newJString(alt))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(query_589047, "callback", newJString(callback))
  add(query_589047, "access_token", newJString(accessToken))
  add(query_589047, "uploadType", newJString(uploadType))
  add(query_589047, "key", newJString(key))
  add(query_589047, "$.xgafv", newJString(Xgafv))
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  result = call_589045.call(path_589046, query_589047, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirDelete* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_589029(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_589030,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirDelete_589031,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_589070 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_589072(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_589071(
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
  var valid_589073 = path.getOrDefault("name")
  valid_589073 = validateParameter(valid_589073, JString, required = true,
                                 default = nil)
  if valid_589073 != nil:
    section.add "name", valid_589073
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
  var valid_589074 = query.getOrDefault("upload_protocol")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "upload_protocol", valid_589074
  var valid_589075 = query.getOrDefault("fields")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "fields", valid_589075
  var valid_589076 = query.getOrDefault("pageToken")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "pageToken", valid_589076
  var valid_589077 = query.getOrDefault("quotaUser")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "quotaUser", valid_589077
  var valid_589078 = query.getOrDefault("alt")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = newJString("json"))
  if valid_589078 != nil:
    section.add "alt", valid_589078
  var valid_589079 = query.getOrDefault("_count")
  valid_589079 = validateParameter(valid_589079, JInt, required = false, default = nil)
  if valid_589079 != nil:
    section.add "_count", valid_589079
  var valid_589080 = query.getOrDefault("end")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "end", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("callback")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "callback", valid_589082
  var valid_589083 = query.getOrDefault("access_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "access_token", valid_589083
  var valid_589084 = query.getOrDefault("uploadType")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "uploadType", valid_589084
  var valid_589085 = query.getOrDefault("key")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "key", valid_589085
  var valid_589086 = query.getOrDefault("$.xgafv")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("1"))
  if valid_589086 != nil:
    section.add "$.xgafv", valid_589086
  var valid_589087 = query.getOrDefault("prettyPrint")
  valid_589087 = validateParameter(valid_589087, JBool, required = false,
                                 default = newJBool(true))
  if valid_589087 != nil:
    section.add "prettyPrint", valid_589087
  var valid_589088 = query.getOrDefault("start")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "start", valid_589088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589089: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_589070;
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
  let valid = call_589089.validator(path, query, header, formData, body)
  let scheme = call_589089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589089.url(scheme.get, call_589089.host, call_589089.base,
                         call_589089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589089, url, valid)

proc call*(call_589090: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_589070;
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
  var path_589091 = newJObject()
  var query_589092 = newJObject()
  add(query_589092, "upload_protocol", newJString(uploadProtocol))
  add(query_589092, "fields", newJString(fields))
  add(query_589092, "pageToken", newJString(pageToken))
  add(query_589092, "quotaUser", newJString(quotaUser))
  add(path_589091, "name", newJString(name))
  add(query_589092, "alt", newJString(alt))
  add(query_589092, "_count", newJInt(Count))
  add(query_589092, "end", newJString(`end`))
  add(query_589092, "oauth_token", newJString(oauthToken))
  add(query_589092, "callback", newJString(callback))
  add(query_589092, "access_token", newJString(accessToken))
  add(query_589092, "uploadType", newJString(uploadType))
  add(query_589092, "key", newJString(key))
  add(query_589092, "$.xgafv", newJString(Xgafv))
  add(query_589092, "prettyPrint", newJBool(prettyPrint))
  add(query_589092, "start", newJString(start))
  result = call_589090.call(path_589091, query_589092, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_589070(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}/$everything", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_589071,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirPatientEverything_589072,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_589093 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_589095(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_589094(
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
  var valid_589096 = path.getOrDefault("name")
  valid_589096 = validateParameter(valid_589096, JString, required = true,
                                 default = nil)
  if valid_589096 != nil:
    section.add "name", valid_589096
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
  var valid_589097 = query.getOrDefault("upload_protocol")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "upload_protocol", valid_589097
  var valid_589098 = query.getOrDefault("fields")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "fields", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("alt")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("json"))
  if valid_589100 != nil:
    section.add "alt", valid_589100
  var valid_589101 = query.getOrDefault("oauth_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "oauth_token", valid_589101
  var valid_589102 = query.getOrDefault("callback")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "callback", valid_589102
  var valid_589103 = query.getOrDefault("access_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "access_token", valid_589103
  var valid_589104 = query.getOrDefault("uploadType")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "uploadType", valid_589104
  var valid_589105 = query.getOrDefault("key")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "key", valid_589105
  var valid_589106 = query.getOrDefault("$.xgafv")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("1"))
  if valid_589106 != nil:
    section.add "$.xgafv", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589108: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_589093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all the historical versions of a resource (excluding the current
  ## version) from the FHIR store. To remove all versions of a resource, first
  ## delete the current version and then call this method.
  ## 
  ## This is not a FHIR standard operation.
  ## 
  let valid = call_589108.validator(path, query, header, formData, body)
  let scheme = call_589108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589108.url(scheme.get, call_589108.host, call_589108.base,
                         call_589108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589108, url, valid)

proc call*(call_589109: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_589093;
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
  var path_589110 = newJObject()
  var query_589111 = newJObject()
  add(query_589111, "upload_protocol", newJString(uploadProtocol))
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(path_589110, "name", newJString(name))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(query_589111, "callback", newJString(callback))
  add(query_589111, "access_token", newJString(accessToken))
  add(query_589111, "uploadType", newJString(uploadType))
  add(query_589111, "key", newJString(key))
  add(query_589111, "$.xgafv", newJString(Xgafv))
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  result = call_589109.call(path_589110, query_589111, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_589093(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}/$purge", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_589094,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirResourcePurge_589095,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_589112 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_589114(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_589113(
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
  var valid_589115 = path.getOrDefault("name")
  valid_589115 = validateParameter(valid_589115, JString, required = true,
                                 default = nil)
  if valid_589115 != nil:
    section.add "name", valid_589115
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
  var valid_589116 = query.getOrDefault("upload_protocol")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "upload_protocol", valid_589116
  var valid_589117 = query.getOrDefault("fields")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "fields", valid_589117
  var valid_589118 = query.getOrDefault("quotaUser")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "quotaUser", valid_589118
  var valid_589119 = query.getOrDefault("at")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "at", valid_589119
  var valid_589120 = query.getOrDefault("alt")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = newJString("json"))
  if valid_589120 != nil:
    section.add "alt", valid_589120
  var valid_589121 = query.getOrDefault("since")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "since", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("callback")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "callback", valid_589123
  var valid_589124 = query.getOrDefault("access_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "access_token", valid_589124
  var valid_589125 = query.getOrDefault("uploadType")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "uploadType", valid_589125
  var valid_589126 = query.getOrDefault("page")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "page", valid_589126
  var valid_589127 = query.getOrDefault("key")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "key", valid_589127
  var valid_589128 = query.getOrDefault("$.xgafv")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = newJString("1"))
  if valid_589128 != nil:
    section.add "$.xgafv", valid_589128
  var valid_589129 = query.getOrDefault("prettyPrint")
  valid_589129 = validateParameter(valid_589129, JBool, required = false,
                                 default = newJBool(true))
  if valid_589129 != nil:
    section.add "prettyPrint", valid_589129
  var valid_589130 = query.getOrDefault("count")
  valid_589130 = validateParameter(valid_589130, JInt, required = false, default = nil)
  if valid_589130 != nil:
    section.add "count", valid_589130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589131: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_589112;
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
  let valid = call_589131.validator(path, query, header, formData, body)
  let scheme = call_589131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589131.url(scheme.get, call_589131.host, call_589131.base,
                         call_589131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589131, url, valid)

proc call*(call_589132: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_589112;
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
  var path_589133 = newJObject()
  var query_589134 = newJObject()
  add(query_589134, "upload_protocol", newJString(uploadProtocol))
  add(query_589134, "fields", newJString(fields))
  add(query_589134, "quotaUser", newJString(quotaUser))
  add(query_589134, "at", newJString(at))
  add(path_589133, "name", newJString(name))
  add(query_589134, "alt", newJString(alt))
  add(query_589134, "since", newJString(since))
  add(query_589134, "oauth_token", newJString(oauthToken))
  add(query_589134, "callback", newJString(callback))
  add(query_589134, "access_token", newJString(accessToken))
  add(query_589134, "uploadType", newJString(uploadType))
  add(query_589134, "page", newJString(page))
  add(query_589134, "key", newJString(key))
  add(query_589134, "$.xgafv", newJString(Xgafv))
  add(query_589134, "prettyPrint", newJBool(prettyPrint))
  add(query_589134, "count", newJInt(count))
  result = call_589132.call(path_589133, query_589134, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirHistory* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_589112(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirHistory",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}/_history", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_589113,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirHistory_589114,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_589135 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_589137(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_589136(
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
  var valid_589138 = path.getOrDefault("name")
  valid_589138 = validateParameter(valid_589138, JString, required = true,
                                 default = nil)
  if valid_589138 != nil:
    section.add "name", valid_589138
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
  var valid_589139 = query.getOrDefault("upload_protocol")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "upload_protocol", valid_589139
  var valid_589140 = query.getOrDefault("fields")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "fields", valid_589140
  var valid_589141 = query.getOrDefault("quotaUser")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "quotaUser", valid_589141
  var valid_589142 = query.getOrDefault("alt")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = newJString("json"))
  if valid_589142 != nil:
    section.add "alt", valid_589142
  var valid_589143 = query.getOrDefault("oauth_token")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "oauth_token", valid_589143
  var valid_589144 = query.getOrDefault("callback")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "callback", valid_589144
  var valid_589145 = query.getOrDefault("access_token")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "access_token", valid_589145
  var valid_589146 = query.getOrDefault("uploadType")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "uploadType", valid_589146
  var valid_589147 = query.getOrDefault("key")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "key", valid_589147
  var valid_589148 = query.getOrDefault("$.xgafv")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = newJString("1"))
  if valid_589148 != nil:
    section.add "$.xgafv", valid_589148
  var valid_589149 = query.getOrDefault("prettyPrint")
  valid_589149 = validateParameter(valid_589149, JBool, required = false,
                                 default = newJBool(true))
  if valid_589149 != nil:
    section.add "prettyPrint", valid_589149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589150: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_589135;
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
  let valid = call_589150.validator(path, query, header, formData, body)
  let scheme = call_589150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589150.url(scheme.get, call_589150.host, call_589150.base,
                         call_589150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589150, url, valid)

proc call*(call_589151: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_589135;
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
  var path_589152 = newJObject()
  var query_589153 = newJObject()
  add(query_589153, "upload_protocol", newJString(uploadProtocol))
  add(query_589153, "fields", newJString(fields))
  add(query_589153, "quotaUser", newJString(quotaUser))
  add(path_589152, "name", newJString(name))
  add(query_589153, "alt", newJString(alt))
  add(query_589153, "oauth_token", newJString(oauthToken))
  add(query_589153, "callback", newJString(callback))
  add(query_589153, "access_token", newJString(accessToken))
  add(query_589153, "uploadType", newJString(uploadType))
  add(query_589153, "key", newJString(key))
  add(query_589153, "$.xgafv", newJString(Xgafv))
  add(query_589153, "prettyPrint", newJBool(prettyPrint))
  result = call_589151.call(path_589152, query_589153, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_589135(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}/fhir/metadata", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_589136,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCapabilities_589137,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsList_589154 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsList_589156(protocol: Scheme; host: string;
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

proc validate_HealthcareProjectsLocationsList_589155(path: JsonNode;
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
  var valid_589157 = path.getOrDefault("name")
  valid_589157 = validateParameter(valid_589157, JString, required = true,
                                 default = nil)
  if valid_589157 != nil:
    section.add "name", valid_589157
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
  var valid_589158 = query.getOrDefault("upload_protocol")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "upload_protocol", valid_589158
  var valid_589159 = query.getOrDefault("fields")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "fields", valid_589159
  var valid_589160 = query.getOrDefault("pageToken")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "pageToken", valid_589160
  var valid_589161 = query.getOrDefault("quotaUser")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "quotaUser", valid_589161
  var valid_589162 = query.getOrDefault("alt")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = newJString("json"))
  if valid_589162 != nil:
    section.add "alt", valid_589162
  var valid_589163 = query.getOrDefault("oauth_token")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "oauth_token", valid_589163
  var valid_589164 = query.getOrDefault("callback")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "callback", valid_589164
  var valid_589165 = query.getOrDefault("access_token")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "access_token", valid_589165
  var valid_589166 = query.getOrDefault("uploadType")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "uploadType", valid_589166
  var valid_589167 = query.getOrDefault("key")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "key", valid_589167
  var valid_589168 = query.getOrDefault("$.xgafv")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = newJString("1"))
  if valid_589168 != nil:
    section.add "$.xgafv", valid_589168
  var valid_589169 = query.getOrDefault("pageSize")
  valid_589169 = validateParameter(valid_589169, JInt, required = false, default = nil)
  if valid_589169 != nil:
    section.add "pageSize", valid_589169
  var valid_589170 = query.getOrDefault("prettyPrint")
  valid_589170 = validateParameter(valid_589170, JBool, required = false,
                                 default = newJBool(true))
  if valid_589170 != nil:
    section.add "prettyPrint", valid_589170
  var valid_589171 = query.getOrDefault("filter")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "filter", valid_589171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589172: Call_HealthcareProjectsLocationsList_589154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589172.validator(path, query, header, formData, body)
  let scheme = call_589172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589172.url(scheme.get, call_589172.host, call_589172.base,
                         call_589172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589172, url, valid)

proc call*(call_589173: Call_HealthcareProjectsLocationsList_589154; name: string;
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
  var path_589174 = newJObject()
  var query_589175 = newJObject()
  add(query_589175, "upload_protocol", newJString(uploadProtocol))
  add(query_589175, "fields", newJString(fields))
  add(query_589175, "pageToken", newJString(pageToken))
  add(query_589175, "quotaUser", newJString(quotaUser))
  add(path_589174, "name", newJString(name))
  add(query_589175, "alt", newJString(alt))
  add(query_589175, "oauth_token", newJString(oauthToken))
  add(query_589175, "callback", newJString(callback))
  add(query_589175, "access_token", newJString(accessToken))
  add(query_589175, "uploadType", newJString(uploadType))
  add(query_589175, "key", newJString(key))
  add(query_589175, "$.xgafv", newJString(Xgafv))
  add(query_589175, "pageSize", newJInt(pageSize))
  add(query_589175, "prettyPrint", newJBool(prettyPrint))
  add(query_589175, "filter", newJString(filter))
  result = call_589173.call(path_589174, query_589175, nil, nil, nil)

var healthcareProjectsLocationsList* = Call_HealthcareProjectsLocationsList_589154(
    name: "healthcareProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "healthcare.googleapis.com", route: "/v1beta1/{name}/locations",
    validator: validate_HealthcareProjectsLocationsList_589155, base: "/",
    url: url_HealthcareProjectsLocationsList_589156, schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsOperationsList_589176 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsOperationsList_589178(
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

proc validate_HealthcareProjectsLocationsDatasetsOperationsList_589177(
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
  var valid_589179 = path.getOrDefault("name")
  valid_589179 = validateParameter(valid_589179, JString, required = true,
                                 default = nil)
  if valid_589179 != nil:
    section.add "name", valid_589179
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
  var valid_589180 = query.getOrDefault("upload_protocol")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "upload_protocol", valid_589180
  var valid_589181 = query.getOrDefault("fields")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "fields", valid_589181
  var valid_589182 = query.getOrDefault("pageToken")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "pageToken", valid_589182
  var valid_589183 = query.getOrDefault("quotaUser")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "quotaUser", valid_589183
  var valid_589184 = query.getOrDefault("alt")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = newJString("json"))
  if valid_589184 != nil:
    section.add "alt", valid_589184
  var valid_589185 = query.getOrDefault("oauth_token")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "oauth_token", valid_589185
  var valid_589186 = query.getOrDefault("callback")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "callback", valid_589186
  var valid_589187 = query.getOrDefault("access_token")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "access_token", valid_589187
  var valid_589188 = query.getOrDefault("uploadType")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "uploadType", valid_589188
  var valid_589189 = query.getOrDefault("key")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "key", valid_589189
  var valid_589190 = query.getOrDefault("$.xgafv")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = newJString("1"))
  if valid_589190 != nil:
    section.add "$.xgafv", valid_589190
  var valid_589191 = query.getOrDefault("pageSize")
  valid_589191 = validateParameter(valid_589191, JInt, required = false, default = nil)
  if valid_589191 != nil:
    section.add "pageSize", valid_589191
  var valid_589192 = query.getOrDefault("prettyPrint")
  valid_589192 = validateParameter(valid_589192, JBool, required = false,
                                 default = newJBool(true))
  if valid_589192 != nil:
    section.add "prettyPrint", valid_589192
  var valid_589193 = query.getOrDefault("filter")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "filter", valid_589193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589194: Call_HealthcareProjectsLocationsDatasetsOperationsList_589176;
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
  let valid = call_589194.validator(path, query, header, formData, body)
  let scheme = call_589194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589194.url(scheme.get, call_589194.host, call_589194.base,
                         call_589194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589194, url, valid)

proc call*(call_589195: Call_HealthcareProjectsLocationsDatasetsOperationsList_589176;
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
  var path_589196 = newJObject()
  var query_589197 = newJObject()
  add(query_589197, "upload_protocol", newJString(uploadProtocol))
  add(query_589197, "fields", newJString(fields))
  add(query_589197, "pageToken", newJString(pageToken))
  add(query_589197, "quotaUser", newJString(quotaUser))
  add(path_589196, "name", newJString(name))
  add(query_589197, "alt", newJString(alt))
  add(query_589197, "oauth_token", newJString(oauthToken))
  add(query_589197, "callback", newJString(callback))
  add(query_589197, "access_token", newJString(accessToken))
  add(query_589197, "uploadType", newJString(uploadType))
  add(query_589197, "key", newJString(key))
  add(query_589197, "$.xgafv", newJString(Xgafv))
  add(query_589197, "pageSize", newJInt(pageSize))
  add(query_589197, "prettyPrint", newJBool(prettyPrint))
  add(query_589197, "filter", newJString(filter))
  result = call_589195.call(path_589196, query_589197, nil, nil, nil)

var healthcareProjectsLocationsDatasetsOperationsList* = Call_HealthcareProjectsLocationsDatasetsOperationsList_589176(
    name: "healthcareProjectsLocationsDatasetsOperationsList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}/operations",
    validator: validate_HealthcareProjectsLocationsDatasetsOperationsList_589177,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsOperationsList_589178,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_589198 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresExport_589200(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresExport_589199(
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
  var valid_589201 = path.getOrDefault("name")
  valid_589201 = validateParameter(valid_589201, JString, required = true,
                                 default = nil)
  if valid_589201 != nil:
    section.add "name", valid_589201
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
  var valid_589202 = query.getOrDefault("upload_protocol")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "upload_protocol", valid_589202
  var valid_589203 = query.getOrDefault("fields")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "fields", valid_589203
  var valid_589204 = query.getOrDefault("quotaUser")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "quotaUser", valid_589204
  var valid_589205 = query.getOrDefault("alt")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("json"))
  if valid_589205 != nil:
    section.add "alt", valid_589205
  var valid_589206 = query.getOrDefault("oauth_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "oauth_token", valid_589206
  var valid_589207 = query.getOrDefault("callback")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "callback", valid_589207
  var valid_589208 = query.getOrDefault("access_token")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "access_token", valid_589208
  var valid_589209 = query.getOrDefault("uploadType")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "uploadType", valid_589209
  var valid_589210 = query.getOrDefault("key")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "key", valid_589210
  var valid_589211 = query.getOrDefault("$.xgafv")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = newJString("1"))
  if valid_589211 != nil:
    section.add "$.xgafv", valid_589211
  var valid_589212 = query.getOrDefault("prettyPrint")
  valid_589212 = validateParameter(valid_589212, JBool, required = false,
                                 default = newJBool(true))
  if valid_589212 != nil:
    section.add "prettyPrint", valid_589212
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

proc call*(call_589214: Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_589198;
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
  let valid = call_589214.validator(path, query, header, formData, body)
  let scheme = call_589214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589214.url(scheme.get, call_589214.host, call_589214.base,
                         call_589214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589214, url, valid)

proc call*(call_589215: Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_589198;
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
  var path_589216 = newJObject()
  var query_589217 = newJObject()
  var body_589218 = newJObject()
  add(query_589217, "upload_protocol", newJString(uploadProtocol))
  add(query_589217, "fields", newJString(fields))
  add(query_589217, "quotaUser", newJString(quotaUser))
  add(path_589216, "name", newJString(name))
  add(query_589217, "alt", newJString(alt))
  add(query_589217, "oauth_token", newJString(oauthToken))
  add(query_589217, "callback", newJString(callback))
  add(query_589217, "access_token", newJString(accessToken))
  add(query_589217, "uploadType", newJString(uploadType))
  add(query_589217, "key", newJString(key))
  add(query_589217, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589218 = body
  add(query_589217, "prettyPrint", newJBool(prettyPrint))
  result = call_589215.call(path_589216, query_589217, nil, nil, body_589218)

var healthcareProjectsLocationsDatasetsFhirStoresExport* = Call_HealthcareProjectsLocationsDatasetsFhirStoresExport_589198(
    name: "healthcareProjectsLocationsDatasetsFhirStoresExport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}:export",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresExport_589199,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresExport_589200,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_589219 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresImport_589221(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresImport_589220(
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
  var valid_589222 = path.getOrDefault("name")
  valid_589222 = validateParameter(valid_589222, JString, required = true,
                                 default = nil)
  if valid_589222 != nil:
    section.add "name", valid_589222
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
  var valid_589223 = query.getOrDefault("upload_protocol")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "upload_protocol", valid_589223
  var valid_589224 = query.getOrDefault("fields")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "fields", valid_589224
  var valid_589225 = query.getOrDefault("quotaUser")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "quotaUser", valid_589225
  var valid_589226 = query.getOrDefault("alt")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = newJString("json"))
  if valid_589226 != nil:
    section.add "alt", valid_589226
  var valid_589227 = query.getOrDefault("oauth_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "oauth_token", valid_589227
  var valid_589228 = query.getOrDefault("callback")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "callback", valid_589228
  var valid_589229 = query.getOrDefault("access_token")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "access_token", valid_589229
  var valid_589230 = query.getOrDefault("uploadType")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "uploadType", valid_589230
  var valid_589231 = query.getOrDefault("key")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "key", valid_589231
  var valid_589232 = query.getOrDefault("$.xgafv")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = newJString("1"))
  if valid_589232 != nil:
    section.add "$.xgafv", valid_589232
  var valid_589233 = query.getOrDefault("prettyPrint")
  valid_589233 = validateParameter(valid_589233, JBool, required = false,
                                 default = newJBool(true))
  if valid_589233 != nil:
    section.add "prettyPrint", valid_589233
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

proc call*(call_589235: Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_589219;
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
  let valid = call_589235.validator(path, query, header, formData, body)
  let scheme = call_589235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589235.url(scheme.get, call_589235.host, call_589235.base,
                         call_589235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589235, url, valid)

proc call*(call_589236: Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_589219;
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
  var path_589237 = newJObject()
  var query_589238 = newJObject()
  var body_589239 = newJObject()
  add(query_589238, "upload_protocol", newJString(uploadProtocol))
  add(query_589238, "fields", newJString(fields))
  add(query_589238, "quotaUser", newJString(quotaUser))
  add(path_589237, "name", newJString(name))
  add(query_589238, "alt", newJString(alt))
  add(query_589238, "oauth_token", newJString(oauthToken))
  add(query_589238, "callback", newJString(callback))
  add(query_589238, "access_token", newJString(accessToken))
  add(query_589238, "uploadType", newJString(uploadType))
  add(query_589238, "key", newJString(key))
  add(query_589238, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589239 = body
  add(query_589238, "prettyPrint", newJBool(prettyPrint))
  result = call_589236.call(path_589237, query_589238, nil, nil, body_589239)

var healthcareProjectsLocationsDatasetsFhirStoresImport* = Call_HealthcareProjectsLocationsDatasetsFhirStoresImport_589219(
    name: "healthcareProjectsLocationsDatasetsFhirStoresImport",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{name}:import",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresImport_589220,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresImport_589221,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsCreate_589261 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsCreate_589263(protocol: Scheme;
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

proc validate_HealthcareProjectsLocationsDatasetsCreate_589262(path: JsonNode;
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
  var valid_589264 = path.getOrDefault("parent")
  valid_589264 = validateParameter(valid_589264, JString, required = true,
                                 default = nil)
  if valid_589264 != nil:
    section.add "parent", valid_589264
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
  var valid_589265 = query.getOrDefault("upload_protocol")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "upload_protocol", valid_589265
  var valid_589266 = query.getOrDefault("fields")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "fields", valid_589266
  var valid_589267 = query.getOrDefault("quotaUser")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "quotaUser", valid_589267
  var valid_589268 = query.getOrDefault("alt")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = newJString("json"))
  if valid_589268 != nil:
    section.add "alt", valid_589268
  var valid_589269 = query.getOrDefault("oauth_token")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "oauth_token", valid_589269
  var valid_589270 = query.getOrDefault("callback")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "callback", valid_589270
  var valid_589271 = query.getOrDefault("access_token")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "access_token", valid_589271
  var valid_589272 = query.getOrDefault("uploadType")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "uploadType", valid_589272
  var valid_589273 = query.getOrDefault("datasetId")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "datasetId", valid_589273
  var valid_589274 = query.getOrDefault("key")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "key", valid_589274
  var valid_589275 = query.getOrDefault("$.xgafv")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = newJString("1"))
  if valid_589275 != nil:
    section.add "$.xgafv", valid_589275
  var valid_589276 = query.getOrDefault("prettyPrint")
  valid_589276 = validateParameter(valid_589276, JBool, required = false,
                                 default = newJBool(true))
  if valid_589276 != nil:
    section.add "prettyPrint", valid_589276
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

proc call*(call_589278: Call_HealthcareProjectsLocationsDatasetsCreate_589261;
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
  let valid = call_589278.validator(path, query, header, formData, body)
  let scheme = call_589278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589278.url(scheme.get, call_589278.host, call_589278.base,
                         call_589278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589278, url, valid)

proc call*(call_589279: Call_HealthcareProjectsLocationsDatasetsCreate_589261;
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
  var path_589280 = newJObject()
  var query_589281 = newJObject()
  var body_589282 = newJObject()
  add(query_589281, "upload_protocol", newJString(uploadProtocol))
  add(query_589281, "fields", newJString(fields))
  add(query_589281, "quotaUser", newJString(quotaUser))
  add(query_589281, "alt", newJString(alt))
  add(query_589281, "oauth_token", newJString(oauthToken))
  add(query_589281, "callback", newJString(callback))
  add(query_589281, "access_token", newJString(accessToken))
  add(query_589281, "uploadType", newJString(uploadType))
  add(path_589280, "parent", newJString(parent))
  add(query_589281, "datasetId", newJString(datasetId))
  add(query_589281, "key", newJString(key))
  add(query_589281, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589282 = body
  add(query_589281, "prettyPrint", newJBool(prettyPrint))
  result = call_589279.call(path_589280, query_589281, nil, nil, body_589282)

var healthcareProjectsLocationsDatasetsCreate* = Call_HealthcareProjectsLocationsDatasetsCreate_589261(
    name: "healthcareProjectsLocationsDatasetsCreate", meth: HttpMethod.HttpPost,
    host: "healthcare.googleapis.com", route: "/v1beta1/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsCreate_589262,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsCreate_589263,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsList_589240 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsList_589242(protocol: Scheme;
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

proc validate_HealthcareProjectsLocationsDatasetsList_589241(path: JsonNode;
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
  var valid_589243 = path.getOrDefault("parent")
  valid_589243 = validateParameter(valid_589243, JString, required = true,
                                 default = nil)
  if valid_589243 != nil:
    section.add "parent", valid_589243
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
  var valid_589244 = query.getOrDefault("upload_protocol")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "upload_protocol", valid_589244
  var valid_589245 = query.getOrDefault("fields")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "fields", valid_589245
  var valid_589246 = query.getOrDefault("pageToken")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "pageToken", valid_589246
  var valid_589247 = query.getOrDefault("quotaUser")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "quotaUser", valid_589247
  var valid_589248 = query.getOrDefault("alt")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = newJString("json"))
  if valid_589248 != nil:
    section.add "alt", valid_589248
  var valid_589249 = query.getOrDefault("oauth_token")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "oauth_token", valid_589249
  var valid_589250 = query.getOrDefault("callback")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "callback", valid_589250
  var valid_589251 = query.getOrDefault("access_token")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "access_token", valid_589251
  var valid_589252 = query.getOrDefault("uploadType")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "uploadType", valid_589252
  var valid_589253 = query.getOrDefault("key")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "key", valid_589253
  var valid_589254 = query.getOrDefault("$.xgafv")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = newJString("1"))
  if valid_589254 != nil:
    section.add "$.xgafv", valid_589254
  var valid_589255 = query.getOrDefault("pageSize")
  valid_589255 = validateParameter(valid_589255, JInt, required = false, default = nil)
  if valid_589255 != nil:
    section.add "pageSize", valid_589255
  var valid_589256 = query.getOrDefault("prettyPrint")
  valid_589256 = validateParameter(valid_589256, JBool, required = false,
                                 default = newJBool(true))
  if valid_589256 != nil:
    section.add "prettyPrint", valid_589256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589257: Call_HealthcareProjectsLocationsDatasetsList_589240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the health datasets in the current project.
  ## 
  let valid = call_589257.validator(path, query, header, formData, body)
  let scheme = call_589257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589257.url(scheme.get, call_589257.host, call_589257.base,
                         call_589257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589257, url, valid)

proc call*(call_589258: Call_HealthcareProjectsLocationsDatasetsList_589240;
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
  var path_589259 = newJObject()
  var query_589260 = newJObject()
  add(query_589260, "upload_protocol", newJString(uploadProtocol))
  add(query_589260, "fields", newJString(fields))
  add(query_589260, "pageToken", newJString(pageToken))
  add(query_589260, "quotaUser", newJString(quotaUser))
  add(query_589260, "alt", newJString(alt))
  add(query_589260, "oauth_token", newJString(oauthToken))
  add(query_589260, "callback", newJString(callback))
  add(query_589260, "access_token", newJString(accessToken))
  add(query_589260, "uploadType", newJString(uploadType))
  add(path_589259, "parent", newJString(parent))
  add(query_589260, "key", newJString(key))
  add(query_589260, "$.xgafv", newJString(Xgafv))
  add(query_589260, "pageSize", newJInt(pageSize))
  add(query_589260, "prettyPrint", newJBool(prettyPrint))
  result = call_589258.call(path_589259, query_589260, nil, nil, nil)

var healthcareProjectsLocationsDatasetsList* = Call_HealthcareProjectsLocationsDatasetsList_589240(
    name: "healthcareProjectsLocationsDatasetsList", meth: HttpMethod.HttpGet,
    host: "healthcare.googleapis.com", route: "/v1beta1/{parent}/datasets",
    validator: validate_HealthcareProjectsLocationsDatasetsList_589241, base: "/",
    url: url_HealthcareProjectsLocationsDatasetsList_589242,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_589305 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_589307(
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

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_589306(
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
  var valid_589308 = path.getOrDefault("parent")
  valid_589308 = validateParameter(valid_589308, JString, required = true,
                                 default = nil)
  if valid_589308 != nil:
    section.add "parent", valid_589308
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
  var valid_589309 = query.getOrDefault("upload_protocol")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "upload_protocol", valid_589309
  var valid_589310 = query.getOrDefault("fields")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "fields", valid_589310
  var valid_589311 = query.getOrDefault("quotaUser")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "quotaUser", valid_589311
  var valid_589312 = query.getOrDefault("alt")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = newJString("json"))
  if valid_589312 != nil:
    section.add "alt", valid_589312
  var valid_589313 = query.getOrDefault("oauth_token")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "oauth_token", valid_589313
  var valid_589314 = query.getOrDefault("callback")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "callback", valid_589314
  var valid_589315 = query.getOrDefault("access_token")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "access_token", valid_589315
  var valid_589316 = query.getOrDefault("uploadType")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "uploadType", valid_589316
  var valid_589317 = query.getOrDefault("key")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "key", valid_589317
  var valid_589318 = query.getOrDefault("$.xgafv")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = newJString("1"))
  if valid_589318 != nil:
    section.add "$.xgafv", valid_589318
  var valid_589319 = query.getOrDefault("dicomStoreId")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "dicomStoreId", valid_589319
  var valid_589320 = query.getOrDefault("prettyPrint")
  valid_589320 = validateParameter(valid_589320, JBool, required = false,
                                 default = newJBool(true))
  if valid_589320 != nil:
    section.add "prettyPrint", valid_589320
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

proc call*(call_589322: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_589305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new DICOM store within the parent dataset.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_589305;
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
  var path_589324 = newJObject()
  var query_589325 = newJObject()
  var body_589326 = newJObject()
  add(query_589325, "upload_protocol", newJString(uploadProtocol))
  add(query_589325, "fields", newJString(fields))
  add(query_589325, "quotaUser", newJString(quotaUser))
  add(query_589325, "alt", newJString(alt))
  add(query_589325, "oauth_token", newJString(oauthToken))
  add(query_589325, "callback", newJString(callback))
  add(query_589325, "access_token", newJString(accessToken))
  add(query_589325, "uploadType", newJString(uploadType))
  add(path_589324, "parent", newJString(parent))
  add(query_589325, "key", newJString(key))
  add(query_589325, "$.xgafv", newJString(Xgafv))
  add(query_589325, "dicomStoreId", newJString(dicomStoreId))
  if body != nil:
    body_589326 = body
  add(query_589325, "prettyPrint", newJBool(prettyPrint))
  result = call_589323.call(path_589324, query_589325, nil, nil, body_589326)

var healthcareProjectsLocationsDatasetsDicomStoresCreate* = Call_HealthcareProjectsLocationsDatasetsDicomStoresCreate_589305(
    name: "healthcareProjectsLocationsDatasetsDicomStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresCreate_589306,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresCreate_589307,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresList_589283 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsDicomStoresList_589285(
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

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresList_589284(
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
  var valid_589286 = path.getOrDefault("parent")
  valid_589286 = validateParameter(valid_589286, JString, required = true,
                                 default = nil)
  if valid_589286 != nil:
    section.add "parent", valid_589286
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
  var valid_589287 = query.getOrDefault("upload_protocol")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "upload_protocol", valid_589287
  var valid_589288 = query.getOrDefault("fields")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "fields", valid_589288
  var valid_589289 = query.getOrDefault("pageToken")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "pageToken", valid_589289
  var valid_589290 = query.getOrDefault("quotaUser")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "quotaUser", valid_589290
  var valid_589291 = query.getOrDefault("alt")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = newJString("json"))
  if valid_589291 != nil:
    section.add "alt", valid_589291
  var valid_589292 = query.getOrDefault("oauth_token")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "oauth_token", valid_589292
  var valid_589293 = query.getOrDefault("callback")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "callback", valid_589293
  var valid_589294 = query.getOrDefault("access_token")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "access_token", valid_589294
  var valid_589295 = query.getOrDefault("uploadType")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "uploadType", valid_589295
  var valid_589296 = query.getOrDefault("key")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "key", valid_589296
  var valid_589297 = query.getOrDefault("$.xgafv")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("1"))
  if valid_589297 != nil:
    section.add "$.xgafv", valid_589297
  var valid_589298 = query.getOrDefault("pageSize")
  valid_589298 = validateParameter(valid_589298, JInt, required = false, default = nil)
  if valid_589298 != nil:
    section.add "pageSize", valid_589298
  var valid_589299 = query.getOrDefault("prettyPrint")
  valid_589299 = validateParameter(valid_589299, JBool, required = false,
                                 default = newJBool(true))
  if valid_589299 != nil:
    section.add "prettyPrint", valid_589299
  var valid_589300 = query.getOrDefault("filter")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "filter", valid_589300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589301: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_589283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the DICOM stores in the given dataset.
  ## 
  let valid = call_589301.validator(path, query, header, formData, body)
  let scheme = call_589301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589301.url(scheme.get, call_589301.host, call_589301.base,
                         call_589301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589301, url, valid)

proc call*(call_589302: Call_HealthcareProjectsLocationsDatasetsDicomStoresList_589283;
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
  var path_589303 = newJObject()
  var query_589304 = newJObject()
  add(query_589304, "upload_protocol", newJString(uploadProtocol))
  add(query_589304, "fields", newJString(fields))
  add(query_589304, "pageToken", newJString(pageToken))
  add(query_589304, "quotaUser", newJString(quotaUser))
  add(query_589304, "alt", newJString(alt))
  add(query_589304, "oauth_token", newJString(oauthToken))
  add(query_589304, "callback", newJString(callback))
  add(query_589304, "access_token", newJString(accessToken))
  add(query_589304, "uploadType", newJString(uploadType))
  add(path_589303, "parent", newJString(parent))
  add(query_589304, "key", newJString(key))
  add(query_589304, "$.xgafv", newJString(Xgafv))
  add(query_589304, "pageSize", newJInt(pageSize))
  add(query_589304, "prettyPrint", newJBool(prettyPrint))
  add(query_589304, "filter", newJString(filter))
  result = call_589302.call(path_589303, query_589304, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresList* = Call_HealthcareProjectsLocationsDatasetsDicomStoresList_589283(
    name: "healthcareProjectsLocationsDatasetsDicomStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomStores",
    validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresList_589284,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresList_589285,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_589347 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_589349(
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

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_589348(
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
  var valid_589350 = path.getOrDefault("parent")
  valid_589350 = validateParameter(valid_589350, JString, required = true,
                                 default = nil)
  if valid_589350 != nil:
    section.add "parent", valid_589350
  var valid_589351 = path.getOrDefault("dicomWebPath")
  valid_589351 = validateParameter(valid_589351, JString, required = true,
                                 default = nil)
  if valid_589351 != nil:
    section.add "dicomWebPath", valid_589351
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
  var valid_589352 = query.getOrDefault("upload_protocol")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "upload_protocol", valid_589352
  var valid_589353 = query.getOrDefault("fields")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "fields", valid_589353
  var valid_589354 = query.getOrDefault("quotaUser")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "quotaUser", valid_589354
  var valid_589355 = query.getOrDefault("alt")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = newJString("json"))
  if valid_589355 != nil:
    section.add "alt", valid_589355
  var valid_589356 = query.getOrDefault("oauth_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "oauth_token", valid_589356
  var valid_589357 = query.getOrDefault("callback")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "callback", valid_589357
  var valid_589358 = query.getOrDefault("access_token")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "access_token", valid_589358
  var valid_589359 = query.getOrDefault("uploadType")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "uploadType", valid_589359
  var valid_589360 = query.getOrDefault("key")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "key", valid_589360
  var valid_589361 = query.getOrDefault("$.xgafv")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = newJString("1"))
  if valid_589361 != nil:
    section.add "$.xgafv", valid_589361
  var valid_589362 = query.getOrDefault("prettyPrint")
  valid_589362 = validateParameter(valid_589362, JBool, required = false,
                                 default = newJBool(true))
  if valid_589362 != nil:
    section.add "prettyPrint", valid_589362
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

proc call*(call_589364: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_589347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## StoreInstances stores DICOM instances associated with study instance unique
  ## identifiers (SUID). See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.5.
  ## 
  let valid = call_589364.validator(path, query, header, formData, body)
  let scheme = call_589364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589364.url(scheme.get, call_589364.host, call_589364.base,
                         call_589364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589364, url, valid)

proc call*(call_589365: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_589347;
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
  var path_589366 = newJObject()
  var query_589367 = newJObject()
  var body_589368 = newJObject()
  add(query_589367, "upload_protocol", newJString(uploadProtocol))
  add(query_589367, "fields", newJString(fields))
  add(query_589367, "quotaUser", newJString(quotaUser))
  add(query_589367, "alt", newJString(alt))
  add(query_589367, "oauth_token", newJString(oauthToken))
  add(query_589367, "callback", newJString(callback))
  add(query_589367, "access_token", newJString(accessToken))
  add(query_589367, "uploadType", newJString(uploadType))
  add(path_589366, "parent", newJString(parent))
  add(query_589367, "key", newJString(key))
  add(query_589367, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589368 = body
  add(query_589367, "prettyPrint", newJBool(prettyPrint))
  add(path_589366, "dicomWebPath", newJString(dicomWebPath))
  result = call_589365.call(path_589366, query_589367, nil, nil, body_589368)

var healthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances* = Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_589347(name: "healthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_589348,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesStoreInstances_589349,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_589327 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_589329(
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

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_589328(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## RetrieveFrames returns instances associated with the given study, series,
  ## SOP Instance UID and frame numbers. See
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
  ##               : The path of the RetrieveFrames DICOMweb request (for example,
  ## 
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}/frames/{frame_list}`).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589330 = path.getOrDefault("parent")
  valid_589330 = validateParameter(valid_589330, JString, required = true,
                                 default = nil)
  if valid_589330 != nil:
    section.add "parent", valid_589330
  var valid_589331 = path.getOrDefault("dicomWebPath")
  valid_589331 = validateParameter(valid_589331, JString, required = true,
                                 default = nil)
  if valid_589331 != nil:
    section.add "dicomWebPath", valid_589331
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
  var valid_589332 = query.getOrDefault("upload_protocol")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "upload_protocol", valid_589332
  var valid_589333 = query.getOrDefault("fields")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "fields", valid_589333
  var valid_589334 = query.getOrDefault("quotaUser")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "quotaUser", valid_589334
  var valid_589335 = query.getOrDefault("alt")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = newJString("json"))
  if valid_589335 != nil:
    section.add "alt", valid_589335
  var valid_589336 = query.getOrDefault("oauth_token")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "oauth_token", valid_589336
  var valid_589337 = query.getOrDefault("callback")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "callback", valid_589337
  var valid_589338 = query.getOrDefault("access_token")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "access_token", valid_589338
  var valid_589339 = query.getOrDefault("uploadType")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "uploadType", valid_589339
  var valid_589340 = query.getOrDefault("key")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "key", valid_589340
  var valid_589341 = query.getOrDefault("$.xgafv")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = newJString("1"))
  if valid_589341 != nil:
    section.add "$.xgafv", valid_589341
  var valid_589342 = query.getOrDefault("prettyPrint")
  valid_589342 = validateParameter(valid_589342, JBool, required = false,
                                 default = newJBool(true))
  if valid_589342 != nil:
    section.add "prettyPrint", valid_589342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589343: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_589327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RetrieveFrames returns instances associated with the given study, series,
  ## SOP Instance UID and frame numbers. See
  ## http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_10.4.
  ## 
  let valid = call_589343.validator(path, query, header, formData, body)
  let scheme = call_589343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589343.url(scheme.get, call_589343.host, call_589343.base,
                         call_589343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589343, url, valid)

proc call*(call_589344: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_589327;
          parent: string; dicomWebPath: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames
  ## RetrieveFrames returns instances associated with the given study, series,
  ## SOP Instance UID and frame numbers. See
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
  ##               : The path of the RetrieveFrames DICOMweb request (for example,
  ## 
  ## `studies/{study_uid}/series/{series_uid}/instances/{instance_uid}/frames/{frame_list}`).
  var path_589345 = newJObject()
  var query_589346 = newJObject()
  add(query_589346, "upload_protocol", newJString(uploadProtocol))
  add(query_589346, "fields", newJString(fields))
  add(query_589346, "quotaUser", newJString(quotaUser))
  add(query_589346, "alt", newJString(alt))
  add(query_589346, "oauth_token", newJString(oauthToken))
  add(query_589346, "callback", newJString(callback))
  add(query_589346, "access_token", newJString(accessToken))
  add(query_589346, "uploadType", newJString(uploadType))
  add(path_589345, "parent", newJString(parent))
  add(query_589346, "key", newJString(key))
  add(query_589346, "$.xgafv", newJString(Xgafv))
  add(query_589346, "prettyPrint", newJBool(prettyPrint))
  add(path_589345, "dicomWebPath", newJString(dicomWebPath))
  result = call_589344.call(path_589345, query_589346, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames* = Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_589327(name: "healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_589328,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesFramesRetrieveFrames_589329,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_589369 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_589371(
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

proc validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_589370(
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
  var valid_589372 = path.getOrDefault("parent")
  valid_589372 = validateParameter(valid_589372, JString, required = true,
                                 default = nil)
  if valid_589372 != nil:
    section.add "parent", valid_589372
  var valid_589373 = path.getOrDefault("dicomWebPath")
  valid_589373 = validateParameter(valid_589373, JString, required = true,
                                 default = nil)
  if valid_589373 != nil:
    section.add "dicomWebPath", valid_589373
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
  var valid_589374 = query.getOrDefault("upload_protocol")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "upload_protocol", valid_589374
  var valid_589375 = query.getOrDefault("fields")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "fields", valid_589375
  var valid_589376 = query.getOrDefault("quotaUser")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "quotaUser", valid_589376
  var valid_589377 = query.getOrDefault("alt")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = newJString("json"))
  if valid_589377 != nil:
    section.add "alt", valid_589377
  var valid_589378 = query.getOrDefault("oauth_token")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "oauth_token", valid_589378
  var valid_589379 = query.getOrDefault("callback")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "callback", valid_589379
  var valid_589380 = query.getOrDefault("access_token")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "access_token", valid_589380
  var valid_589381 = query.getOrDefault("uploadType")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "uploadType", valid_589381
  var valid_589382 = query.getOrDefault("key")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "key", valid_589382
  var valid_589383 = query.getOrDefault("$.xgafv")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = newJString("1"))
  if valid_589383 != nil:
    section.add "$.xgafv", valid_589383
  var valid_589384 = query.getOrDefault("prettyPrint")
  valid_589384 = validateParameter(valid_589384, JBool, required = false,
                                 default = newJBool(true))
  if valid_589384 != nil:
    section.add "prettyPrint", valid_589384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589385: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_589369;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## DeleteInstance deletes an instance associated with the given study, series,
  ## and SOP Instance UID. Delete requests are equivalent to the GET requests
  ## specified in the WADO-RS standard.
  ## 
  let valid = call_589385.validator(path, query, header, formData, body)
  let scheme = call_589385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589385.url(scheme.get, call_589385.host, call_589385.base,
                         call_589385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589385, url, valid)

proc call*(call_589386: Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_589369;
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
  var path_589387 = newJObject()
  var query_589388 = newJObject()
  add(query_589388, "upload_protocol", newJString(uploadProtocol))
  add(query_589388, "fields", newJString(fields))
  add(query_589388, "quotaUser", newJString(quotaUser))
  add(query_589388, "alt", newJString(alt))
  add(query_589388, "oauth_token", newJString(oauthToken))
  add(query_589388, "callback", newJString(callback))
  add(query_589388, "access_token", newJString(accessToken))
  add(query_589388, "uploadType", newJString(uploadType))
  add(path_589387, "parent", newJString(parent))
  add(query_589388, "key", newJString(key))
  add(query_589388, "$.xgafv", newJString(Xgafv))
  add(query_589388, "prettyPrint", newJBool(prettyPrint))
  add(path_589387, "dicomWebPath", newJString(dicomWebPath))
  result = call_589386.call(path_589387, query_589388, nil, nil, nil)

var healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete* = Call_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_589369(name: "healthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/dicomWeb/{dicomWebPath}", validator: validate_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_589370,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDicomStoresStudiesSeriesInstancesDelete_589371,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_589389 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_589391(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_589390(
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
  var valid_589392 = path.getOrDefault("parent")
  valid_589392 = validateParameter(valid_589392, JString, required = true,
                                 default = nil)
  if valid_589392 != nil:
    section.add "parent", valid_589392
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
  var valid_589393 = query.getOrDefault("upload_protocol")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "upload_protocol", valid_589393
  var valid_589394 = query.getOrDefault("fields")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "fields", valid_589394
  var valid_589395 = query.getOrDefault("quotaUser")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "quotaUser", valid_589395
  var valid_589396 = query.getOrDefault("alt")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = newJString("json"))
  if valid_589396 != nil:
    section.add "alt", valid_589396
  var valid_589397 = query.getOrDefault("oauth_token")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "oauth_token", valid_589397
  var valid_589398 = query.getOrDefault("callback")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "callback", valid_589398
  var valid_589399 = query.getOrDefault("access_token")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "access_token", valid_589399
  var valid_589400 = query.getOrDefault("uploadType")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "uploadType", valid_589400
  var valid_589401 = query.getOrDefault("key")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "key", valid_589401
  var valid_589402 = query.getOrDefault("$.xgafv")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = newJString("1"))
  if valid_589402 != nil:
    section.add "$.xgafv", valid_589402
  var valid_589403 = query.getOrDefault("prettyPrint")
  valid_589403 = validateParameter(valid_589403, JBool, required = false,
                                 default = newJBool(true))
  if valid_589403 != nil:
    section.add "prettyPrint", valid_589403
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

proc call*(call_589405: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_589389;
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
  let valid = call_589405.validator(path, query, header, formData, body)
  let scheme = call_589405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589405.url(scheme.get, call_589405.host, call_589405.base,
                         call_589405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589405, url, valid)

proc call*(call_589406: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_589389;
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
  var path_589407 = newJObject()
  var query_589408 = newJObject()
  var body_589409 = newJObject()
  add(query_589408, "upload_protocol", newJString(uploadProtocol))
  add(query_589408, "fields", newJString(fields))
  add(query_589408, "quotaUser", newJString(quotaUser))
  add(query_589408, "alt", newJString(alt))
  add(query_589408, "oauth_token", newJString(oauthToken))
  add(query_589408, "callback", newJString(callback))
  add(query_589408, "access_token", newJString(accessToken))
  add(query_589408, "uploadType", newJString(uploadType))
  add(path_589407, "parent", newJString(parent))
  add(query_589408, "key", newJString(key))
  add(query_589408, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589409 = body
  add(query_589408, "prettyPrint", newJBool(prettyPrint))
  result = call_589406.call(path_589407, query_589408, nil, nil, body_589409)

var healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_589389(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_589390,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirExecuteBundle_589391,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_589410 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_589412(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_589411(
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
  var valid_589413 = path.getOrDefault("parent")
  valid_589413 = validateParameter(valid_589413, JString, required = true,
                                 default = nil)
  if valid_589413 != nil:
    section.add "parent", valid_589413
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
  var valid_589414 = query.getOrDefault("upload_protocol")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "upload_protocol", valid_589414
  var valid_589415 = query.getOrDefault("fields")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "fields", valid_589415
  var valid_589416 = query.getOrDefault("quotaUser")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "quotaUser", valid_589416
  var valid_589417 = query.getOrDefault("alt")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = newJString("json"))
  if valid_589417 != nil:
    section.add "alt", valid_589417
  var valid_589418 = query.getOrDefault("oauth_token")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "oauth_token", valid_589418
  var valid_589419 = query.getOrDefault("callback")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "callback", valid_589419
  var valid_589420 = query.getOrDefault("access_token")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "access_token", valid_589420
  var valid_589421 = query.getOrDefault("uploadType")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "uploadType", valid_589421
  var valid_589422 = query.getOrDefault("key")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "key", valid_589422
  var valid_589423 = query.getOrDefault("$.xgafv")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = newJString("1"))
  if valid_589423 != nil:
    section.add "$.xgafv", valid_589423
  var valid_589424 = query.getOrDefault("prettyPrint")
  valid_589424 = validateParameter(valid_589424, JBool, required = false,
                                 default = newJBool(true))
  if valid_589424 != nil:
    section.add "prettyPrint", valid_589424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589425: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_589410;
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
  let valid = call_589425.validator(path, query, header, formData, body)
  let scheme = call_589425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589425.url(scheme.get, call_589425.host, call_589425.base,
                         call_589425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589425, url, valid)

proc call*(call_589426: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_589410;
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
  var path_589427 = newJObject()
  var query_589428 = newJObject()
  add(query_589428, "upload_protocol", newJString(uploadProtocol))
  add(query_589428, "fields", newJString(fields))
  add(query_589428, "quotaUser", newJString(quotaUser))
  add(query_589428, "alt", newJString(alt))
  add(query_589428, "oauth_token", newJString(oauthToken))
  add(query_589428, "callback", newJString(callback))
  add(query_589428, "access_token", newJString(accessToken))
  add(query_589428, "uploadType", newJString(uploadType))
  add(path_589427, "parent", newJString(parent))
  add(query_589428, "key", newJString(key))
  add(query_589428, "$.xgafv", newJString(Xgafv))
  add(query_589428, "prettyPrint", newJBool(prettyPrint))
  result = call_589426.call(path_589427, query_589428, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_589410(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/Observation/$lastn", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_589411,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirObservationLastn_589412,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_589429 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_589431(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_589430(
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
  var valid_589432 = path.getOrDefault("parent")
  valid_589432 = validateParameter(valid_589432, JString, required = true,
                                 default = nil)
  if valid_589432 != nil:
    section.add "parent", valid_589432
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
  var valid_589433 = query.getOrDefault("upload_protocol")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "upload_protocol", valid_589433
  var valid_589434 = query.getOrDefault("fields")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "fields", valid_589434
  var valid_589435 = query.getOrDefault("quotaUser")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "quotaUser", valid_589435
  var valid_589436 = query.getOrDefault("alt")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = newJString("json"))
  if valid_589436 != nil:
    section.add "alt", valid_589436
  var valid_589437 = query.getOrDefault("oauth_token")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "oauth_token", valid_589437
  var valid_589438 = query.getOrDefault("callback")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "callback", valid_589438
  var valid_589439 = query.getOrDefault("access_token")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "access_token", valid_589439
  var valid_589440 = query.getOrDefault("uploadType")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "uploadType", valid_589440
  var valid_589441 = query.getOrDefault("key")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "key", valid_589441
  var valid_589442 = query.getOrDefault("$.xgafv")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = newJString("1"))
  if valid_589442 != nil:
    section.add "$.xgafv", valid_589442
  var valid_589443 = query.getOrDefault("prettyPrint")
  valid_589443 = validateParameter(valid_589443, JBool, required = false,
                                 default = newJBool(true))
  if valid_589443 != nil:
    section.add "prettyPrint", valid_589443
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

proc call*(call_589445: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_589429;
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
  let valid = call_589445.validator(path, query, header, formData, body)
  let scheme = call_589445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589445.url(scheme.get, call_589445.host, call_589445.base,
                         call_589445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589445, url, valid)

proc call*(call_589446: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_589429;
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
  var path_589447 = newJObject()
  var query_589448 = newJObject()
  var body_589449 = newJObject()
  add(query_589448, "upload_protocol", newJString(uploadProtocol))
  add(query_589448, "fields", newJString(fields))
  add(query_589448, "quotaUser", newJString(quotaUser))
  add(query_589448, "alt", newJString(alt))
  add(query_589448, "oauth_token", newJString(oauthToken))
  add(query_589448, "callback", newJString(callback))
  add(query_589448, "access_token", newJString(accessToken))
  add(query_589448, "uploadType", newJString(uploadType))
  add(path_589447, "parent", newJString(parent))
  add(query_589448, "key", newJString(key))
  add(query_589448, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589449 = body
  add(query_589448, "prettyPrint", newJBool(prettyPrint))
  result = call_589446.call(path_589447, query_589448, nil, nil, body_589449)

var healthcareProjectsLocationsDatasetsFhirStoresFhirSearch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_589429(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirSearch",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/_search", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_589430,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirSearch_589431,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_589450 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_589452(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_589451(
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
  var valid_589453 = path.getOrDefault("type")
  valid_589453 = validateParameter(valid_589453, JString, required = true,
                                 default = nil)
  if valid_589453 != nil:
    section.add "type", valid_589453
  var valid_589454 = path.getOrDefault("parent")
  valid_589454 = validateParameter(valid_589454, JString, required = true,
                                 default = nil)
  if valid_589454 != nil:
    section.add "parent", valid_589454
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
  var valid_589455 = query.getOrDefault("upload_protocol")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "upload_protocol", valid_589455
  var valid_589456 = query.getOrDefault("fields")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "fields", valid_589456
  var valid_589457 = query.getOrDefault("quotaUser")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "quotaUser", valid_589457
  var valid_589458 = query.getOrDefault("alt")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = newJString("json"))
  if valid_589458 != nil:
    section.add "alt", valid_589458
  var valid_589459 = query.getOrDefault("oauth_token")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "oauth_token", valid_589459
  var valid_589460 = query.getOrDefault("callback")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "callback", valid_589460
  var valid_589461 = query.getOrDefault("access_token")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "access_token", valid_589461
  var valid_589462 = query.getOrDefault("uploadType")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "uploadType", valid_589462
  var valid_589463 = query.getOrDefault("key")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "key", valid_589463
  var valid_589464 = query.getOrDefault("$.xgafv")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = newJString("1"))
  if valid_589464 != nil:
    section.add "$.xgafv", valid_589464
  var valid_589465 = query.getOrDefault("prettyPrint")
  valid_589465 = validateParameter(valid_589465, JBool, required = false,
                                 default = newJBool(true))
  if valid_589465 != nil:
    section.add "prettyPrint", valid_589465
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

proc call*(call_589467: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_589450;
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
  let valid = call_589467.validator(path, query, header, formData, body)
  let scheme = call_589467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589467.url(scheme.get, call_589467.host, call_589467.base,
                         call_589467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589467, url, valid)

proc call*(call_589468: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_589450;
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
  var path_589469 = newJObject()
  var query_589470 = newJObject()
  var body_589471 = newJObject()
  add(path_589469, "type", newJString(`type`))
  add(query_589470, "upload_protocol", newJString(uploadProtocol))
  add(query_589470, "fields", newJString(fields))
  add(query_589470, "quotaUser", newJString(quotaUser))
  add(query_589470, "alt", newJString(alt))
  add(query_589470, "oauth_token", newJString(oauthToken))
  add(query_589470, "callback", newJString(callback))
  add(query_589470, "access_token", newJString(accessToken))
  add(query_589470, "uploadType", newJString(uploadType))
  add(path_589469, "parent", newJString(parent))
  add(query_589470, "key", newJString(key))
  add(query_589470, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589471 = body
  add(query_589470, "prettyPrint", newJBool(prettyPrint))
  result = call_589468.call(path_589469, query_589470, nil, nil, body_589471)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_589450(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate",
    meth: HttpMethod.HttpPut, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_589451,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalUpdate_589452,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_589472 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_589474(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_589473(
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
  var valid_589475 = path.getOrDefault("type")
  valid_589475 = validateParameter(valid_589475, JString, required = true,
                                 default = nil)
  if valid_589475 != nil:
    section.add "type", valid_589475
  var valid_589476 = path.getOrDefault("parent")
  valid_589476 = validateParameter(valid_589476, JString, required = true,
                                 default = nil)
  if valid_589476 != nil:
    section.add "parent", valid_589476
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
  var valid_589477 = query.getOrDefault("upload_protocol")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "upload_protocol", valid_589477
  var valid_589478 = query.getOrDefault("fields")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "fields", valid_589478
  var valid_589479 = query.getOrDefault("quotaUser")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "quotaUser", valid_589479
  var valid_589480 = query.getOrDefault("alt")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = newJString("json"))
  if valid_589480 != nil:
    section.add "alt", valid_589480
  var valid_589481 = query.getOrDefault("oauth_token")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "oauth_token", valid_589481
  var valid_589482 = query.getOrDefault("callback")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "callback", valid_589482
  var valid_589483 = query.getOrDefault("access_token")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "access_token", valid_589483
  var valid_589484 = query.getOrDefault("uploadType")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "uploadType", valid_589484
  var valid_589485 = query.getOrDefault("key")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "key", valid_589485
  var valid_589486 = query.getOrDefault("$.xgafv")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = newJString("1"))
  if valid_589486 != nil:
    section.add "$.xgafv", valid_589486
  var valid_589487 = query.getOrDefault("prettyPrint")
  valid_589487 = validateParameter(valid_589487, JBool, required = false,
                                 default = newJBool(true))
  if valid_589487 != nil:
    section.add "prettyPrint", valid_589487
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

proc call*(call_589489: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_589472;
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
  let valid = call_589489.validator(path, query, header, formData, body)
  let scheme = call_589489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589489.url(scheme.get, call_589489.host, call_589489.base,
                         call_589489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589489, url, valid)

proc call*(call_589490: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_589472;
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
  var path_589491 = newJObject()
  var query_589492 = newJObject()
  var body_589493 = newJObject()
  add(path_589491, "type", newJString(`type`))
  add(query_589492, "upload_protocol", newJString(uploadProtocol))
  add(query_589492, "fields", newJString(fields))
  add(query_589492, "quotaUser", newJString(quotaUser))
  add(query_589492, "alt", newJString(alt))
  add(query_589492, "oauth_token", newJString(oauthToken))
  add(query_589492, "callback", newJString(callback))
  add(query_589492, "access_token", newJString(accessToken))
  add(query_589492, "uploadType", newJString(uploadType))
  add(path_589491, "parent", newJString(parent))
  add(query_589492, "key", newJString(key))
  add(query_589492, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589493 = body
  add(query_589492, "prettyPrint", newJBool(prettyPrint))
  result = call_589490.call(path_589491, query_589492, nil, nil, body_589493)

var healthcareProjectsLocationsDatasetsFhirStoresFhirCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_589472(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_589473,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirCreate_589474,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_589514 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_589516(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_589515(
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
  var valid_589517 = path.getOrDefault("type")
  valid_589517 = validateParameter(valid_589517, JString, required = true,
                                 default = nil)
  if valid_589517 != nil:
    section.add "type", valid_589517
  var valid_589518 = path.getOrDefault("parent")
  valid_589518 = validateParameter(valid_589518, JString, required = true,
                                 default = nil)
  if valid_589518 != nil:
    section.add "parent", valid_589518
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
  var valid_589519 = query.getOrDefault("upload_protocol")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "upload_protocol", valid_589519
  var valid_589520 = query.getOrDefault("fields")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "fields", valid_589520
  var valid_589521 = query.getOrDefault("quotaUser")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "quotaUser", valid_589521
  var valid_589522 = query.getOrDefault("alt")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = newJString("json"))
  if valid_589522 != nil:
    section.add "alt", valid_589522
  var valid_589523 = query.getOrDefault("oauth_token")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "oauth_token", valid_589523
  var valid_589524 = query.getOrDefault("callback")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "callback", valid_589524
  var valid_589525 = query.getOrDefault("access_token")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "access_token", valid_589525
  var valid_589526 = query.getOrDefault("uploadType")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "uploadType", valid_589526
  var valid_589527 = query.getOrDefault("key")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "key", valid_589527
  var valid_589528 = query.getOrDefault("$.xgafv")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = newJString("1"))
  if valid_589528 != nil:
    section.add "$.xgafv", valid_589528
  var valid_589529 = query.getOrDefault("prettyPrint")
  valid_589529 = validateParameter(valid_589529, JBool, required = false,
                                 default = newJBool(true))
  if valid_589529 != nil:
    section.add "prettyPrint", valid_589529
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

proc call*(call_589531: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_589514;
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
  let valid = call_589531.validator(path, query, header, formData, body)
  let scheme = call_589531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589531.url(scheme.get, call_589531.host, call_589531.base,
                         call_589531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589531, url, valid)

proc call*(call_589532: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_589514;
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
  var path_589533 = newJObject()
  var query_589534 = newJObject()
  var body_589535 = newJObject()
  add(path_589533, "type", newJString(`type`))
  add(query_589534, "upload_protocol", newJString(uploadProtocol))
  add(query_589534, "fields", newJString(fields))
  add(query_589534, "quotaUser", newJString(quotaUser))
  add(query_589534, "alt", newJString(alt))
  add(query_589534, "oauth_token", newJString(oauthToken))
  add(query_589534, "callback", newJString(callback))
  add(query_589534, "access_token", newJString(accessToken))
  add(query_589534, "uploadType", newJString(uploadType))
  add(path_589533, "parent", newJString(parent))
  add(query_589534, "key", newJString(key))
  add(query_589534, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589535 = body
  add(query_589534, "prettyPrint", newJBool(prettyPrint))
  result = call_589532.call(path_589533, query_589534, nil, nil, body_589535)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_589514(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch",
    meth: HttpMethod.HttpPatch, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_589515,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalPatch_589516,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_589494 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_589496(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_589495(
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
  var valid_589497 = path.getOrDefault("type")
  valid_589497 = validateParameter(valid_589497, JString, required = true,
                                 default = nil)
  if valid_589497 != nil:
    section.add "type", valid_589497
  var valid_589498 = path.getOrDefault("parent")
  valid_589498 = validateParameter(valid_589498, JString, required = true,
                                 default = nil)
  if valid_589498 != nil:
    section.add "parent", valid_589498
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
  var valid_589499 = query.getOrDefault("upload_protocol")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "upload_protocol", valid_589499
  var valid_589500 = query.getOrDefault("fields")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "fields", valid_589500
  var valid_589501 = query.getOrDefault("quotaUser")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "quotaUser", valid_589501
  var valid_589502 = query.getOrDefault("alt")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = newJString("json"))
  if valid_589502 != nil:
    section.add "alt", valid_589502
  var valid_589503 = query.getOrDefault("oauth_token")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "oauth_token", valid_589503
  var valid_589504 = query.getOrDefault("callback")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "callback", valid_589504
  var valid_589505 = query.getOrDefault("access_token")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "access_token", valid_589505
  var valid_589506 = query.getOrDefault("uploadType")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "uploadType", valid_589506
  var valid_589507 = query.getOrDefault("key")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "key", valid_589507
  var valid_589508 = query.getOrDefault("$.xgafv")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = newJString("1"))
  if valid_589508 != nil:
    section.add "$.xgafv", valid_589508
  var valid_589509 = query.getOrDefault("prettyPrint")
  valid_589509 = validateParameter(valid_589509, JBool, required = false,
                                 default = newJBool(true))
  if valid_589509 != nil:
    section.add "prettyPrint", valid_589509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589510: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_589494;
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
  let valid = call_589510.validator(path, query, header, formData, body)
  let scheme = call_589510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589510.url(scheme.get, call_589510.host, call_589510.base,
                         call_589510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589510, url, valid)

proc call*(call_589511: Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_589494;
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
  var path_589512 = newJObject()
  var query_589513 = newJObject()
  add(path_589512, "type", newJString(`type`))
  add(query_589513, "upload_protocol", newJString(uploadProtocol))
  add(query_589513, "fields", newJString(fields))
  add(query_589513, "quotaUser", newJString(quotaUser))
  add(query_589513, "alt", newJString(alt))
  add(query_589513, "oauth_token", newJString(oauthToken))
  add(query_589513, "callback", newJString(callback))
  add(query_589513, "access_token", newJString(accessToken))
  add(query_589513, "uploadType", newJString(uploadType))
  add(path_589512, "parent", newJString(parent))
  add(query_589513, "key", newJString(key))
  add(query_589513, "$.xgafv", newJString(Xgafv))
  add(query_589513, "prettyPrint", newJBool(prettyPrint))
  result = call_589511.call(path_589512, query_589513, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete* = Call_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_589494(
    name: "healthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete",
    meth: HttpMethod.HttpDelete, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhir/{type}", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_589495,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresFhirConditionalDelete_589496,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_589558 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_589560(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_589559(
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
  var valid_589561 = path.getOrDefault("parent")
  valid_589561 = validateParameter(valid_589561, JString, required = true,
                                 default = nil)
  if valid_589561 != nil:
    section.add "parent", valid_589561
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
  var valid_589562 = query.getOrDefault("upload_protocol")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "upload_protocol", valid_589562
  var valid_589563 = query.getOrDefault("fields")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "fields", valid_589563
  var valid_589564 = query.getOrDefault("quotaUser")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "quotaUser", valid_589564
  var valid_589565 = query.getOrDefault("alt")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = newJString("json"))
  if valid_589565 != nil:
    section.add "alt", valid_589565
  var valid_589566 = query.getOrDefault("oauth_token")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "oauth_token", valid_589566
  var valid_589567 = query.getOrDefault("callback")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "callback", valid_589567
  var valid_589568 = query.getOrDefault("access_token")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = nil)
  if valid_589568 != nil:
    section.add "access_token", valid_589568
  var valid_589569 = query.getOrDefault("uploadType")
  valid_589569 = validateParameter(valid_589569, JString, required = false,
                                 default = nil)
  if valid_589569 != nil:
    section.add "uploadType", valid_589569
  var valid_589570 = query.getOrDefault("fhirStoreId")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = nil)
  if valid_589570 != nil:
    section.add "fhirStoreId", valid_589570
  var valid_589571 = query.getOrDefault("key")
  valid_589571 = validateParameter(valid_589571, JString, required = false,
                                 default = nil)
  if valid_589571 != nil:
    section.add "key", valid_589571
  var valid_589572 = query.getOrDefault("$.xgafv")
  valid_589572 = validateParameter(valid_589572, JString, required = false,
                                 default = newJString("1"))
  if valid_589572 != nil:
    section.add "$.xgafv", valid_589572
  var valid_589573 = query.getOrDefault("prettyPrint")
  valid_589573 = validateParameter(valid_589573, JBool, required = false,
                                 default = newJBool(true))
  if valid_589573 != nil:
    section.add "prettyPrint", valid_589573
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

proc call*(call_589575: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_589558;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new FHIR store within the parent dataset.
  ## 
  let valid = call_589575.validator(path, query, header, formData, body)
  let scheme = call_589575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589575.url(scheme.get, call_589575.host, call_589575.base,
                         call_589575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589575, url, valid)

proc call*(call_589576: Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_589558;
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
  var path_589577 = newJObject()
  var query_589578 = newJObject()
  var body_589579 = newJObject()
  add(query_589578, "upload_protocol", newJString(uploadProtocol))
  add(query_589578, "fields", newJString(fields))
  add(query_589578, "quotaUser", newJString(quotaUser))
  add(query_589578, "alt", newJString(alt))
  add(query_589578, "oauth_token", newJString(oauthToken))
  add(query_589578, "callback", newJString(callback))
  add(query_589578, "access_token", newJString(accessToken))
  add(query_589578, "uploadType", newJString(uploadType))
  add(path_589577, "parent", newJString(parent))
  add(query_589578, "fhirStoreId", newJString(fhirStoreId))
  add(query_589578, "key", newJString(key))
  add(query_589578, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589579 = body
  add(query_589578, "prettyPrint", newJBool(prettyPrint))
  result = call_589576.call(path_589577, query_589578, nil, nil, body_589579)

var healthcareProjectsLocationsDatasetsFhirStoresCreate* = Call_HealthcareProjectsLocationsDatasetsFhirStoresCreate_589558(
    name: "healthcareProjectsLocationsDatasetsFhirStoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresCreate_589559,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresCreate_589560,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresList_589536 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresList_589538(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresList_589537(
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
  var valid_589539 = path.getOrDefault("parent")
  valid_589539 = validateParameter(valid_589539, JString, required = true,
                                 default = nil)
  if valid_589539 != nil:
    section.add "parent", valid_589539
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
  var valid_589540 = query.getOrDefault("upload_protocol")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "upload_protocol", valid_589540
  var valid_589541 = query.getOrDefault("fields")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "fields", valid_589541
  var valid_589542 = query.getOrDefault("pageToken")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "pageToken", valid_589542
  var valid_589543 = query.getOrDefault("quotaUser")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "quotaUser", valid_589543
  var valid_589544 = query.getOrDefault("alt")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = newJString("json"))
  if valid_589544 != nil:
    section.add "alt", valid_589544
  var valid_589545 = query.getOrDefault("oauth_token")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "oauth_token", valid_589545
  var valid_589546 = query.getOrDefault("callback")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "callback", valid_589546
  var valid_589547 = query.getOrDefault("access_token")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "access_token", valid_589547
  var valid_589548 = query.getOrDefault("uploadType")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = nil)
  if valid_589548 != nil:
    section.add "uploadType", valid_589548
  var valid_589549 = query.getOrDefault("key")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "key", valid_589549
  var valid_589550 = query.getOrDefault("$.xgafv")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = newJString("1"))
  if valid_589550 != nil:
    section.add "$.xgafv", valid_589550
  var valid_589551 = query.getOrDefault("pageSize")
  valid_589551 = validateParameter(valid_589551, JInt, required = false, default = nil)
  if valid_589551 != nil:
    section.add "pageSize", valid_589551
  var valid_589552 = query.getOrDefault("prettyPrint")
  valid_589552 = validateParameter(valid_589552, JBool, required = false,
                                 default = newJBool(true))
  if valid_589552 != nil:
    section.add "prettyPrint", valid_589552
  var valid_589553 = query.getOrDefault("filter")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "filter", valid_589553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589554: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_589536;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the FHIR stores in the given dataset.
  ## 
  let valid = call_589554.validator(path, query, header, formData, body)
  let scheme = call_589554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589554.url(scheme.get, call_589554.host, call_589554.base,
                         call_589554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589554, url, valid)

proc call*(call_589555: Call_HealthcareProjectsLocationsDatasetsFhirStoresList_589536;
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
  var path_589556 = newJObject()
  var query_589557 = newJObject()
  add(query_589557, "upload_protocol", newJString(uploadProtocol))
  add(query_589557, "fields", newJString(fields))
  add(query_589557, "pageToken", newJString(pageToken))
  add(query_589557, "quotaUser", newJString(quotaUser))
  add(query_589557, "alt", newJString(alt))
  add(query_589557, "oauth_token", newJString(oauthToken))
  add(query_589557, "callback", newJString(callback))
  add(query_589557, "access_token", newJString(accessToken))
  add(query_589557, "uploadType", newJString(uploadType))
  add(path_589556, "parent", newJString(parent))
  add(query_589557, "key", newJString(key))
  add(query_589557, "$.xgafv", newJString(Xgafv))
  add(query_589557, "pageSize", newJInt(pageSize))
  add(query_589557, "prettyPrint", newJBool(prettyPrint))
  add(query_589557, "filter", newJString(filter))
  result = call_589555.call(path_589556, query_589557, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresList* = Call_HealthcareProjectsLocationsDatasetsFhirStoresList_589536(
    name: "healthcareProjectsLocationsDatasetsFhirStoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/fhirStores",
    validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresList_589537,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresList_589538,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_589602 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_589604(
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

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_589603(
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
  var valid_589605 = path.getOrDefault("parent")
  valid_589605 = validateParameter(valid_589605, JString, required = true,
                                 default = nil)
  if valid_589605 != nil:
    section.add "parent", valid_589605
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
  var valid_589606 = query.getOrDefault("upload_protocol")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "upload_protocol", valid_589606
  var valid_589607 = query.getOrDefault("fields")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "fields", valid_589607
  var valid_589608 = query.getOrDefault("quotaUser")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "quotaUser", valid_589608
  var valid_589609 = query.getOrDefault("alt")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = newJString("json"))
  if valid_589609 != nil:
    section.add "alt", valid_589609
  var valid_589610 = query.getOrDefault("oauth_token")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = nil)
  if valid_589610 != nil:
    section.add "oauth_token", valid_589610
  var valid_589611 = query.getOrDefault("callback")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "callback", valid_589611
  var valid_589612 = query.getOrDefault("access_token")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "access_token", valid_589612
  var valid_589613 = query.getOrDefault("uploadType")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "uploadType", valid_589613
  var valid_589614 = query.getOrDefault("hl7V2StoreId")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "hl7V2StoreId", valid_589614
  var valid_589615 = query.getOrDefault("key")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = nil)
  if valid_589615 != nil:
    section.add "key", valid_589615
  var valid_589616 = query.getOrDefault("$.xgafv")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = newJString("1"))
  if valid_589616 != nil:
    section.add "$.xgafv", valid_589616
  var valid_589617 = query.getOrDefault("prettyPrint")
  valid_589617 = validateParameter(valid_589617, JBool, required = false,
                                 default = newJBool(true))
  if valid_589617 != nil:
    section.add "prettyPrint", valid_589617
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

proc call*(call_589619: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_589602;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new HL7v2 store within the parent dataset.
  ## 
  let valid = call_589619.validator(path, query, header, formData, body)
  let scheme = call_589619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589619.url(scheme.get, call_589619.host, call_589619.base,
                         call_589619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589619, url, valid)

proc call*(call_589620: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_589602;
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
  var path_589621 = newJObject()
  var query_589622 = newJObject()
  var body_589623 = newJObject()
  add(query_589622, "upload_protocol", newJString(uploadProtocol))
  add(query_589622, "fields", newJString(fields))
  add(query_589622, "quotaUser", newJString(quotaUser))
  add(query_589622, "alt", newJString(alt))
  add(query_589622, "oauth_token", newJString(oauthToken))
  add(query_589622, "callback", newJString(callback))
  add(query_589622, "access_token", newJString(accessToken))
  add(query_589622, "uploadType", newJString(uploadType))
  add(path_589621, "parent", newJString(parent))
  add(query_589622, "hl7V2StoreId", newJString(hl7V2StoreId))
  add(query_589622, "key", newJString(key))
  add(query_589622, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589623 = body
  add(query_589622, "prettyPrint", newJBool(prettyPrint))
  result = call_589620.call(path_589621, query_589622, nil, nil, body_589623)

var healthcareProjectsLocationsDatasetsHl7V2StoresCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_589602(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_589603,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresCreate_589604,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_589580 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_589582(
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

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_589581(
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
  var valid_589583 = path.getOrDefault("parent")
  valid_589583 = validateParameter(valid_589583, JString, required = true,
                                 default = nil)
  if valid_589583 != nil:
    section.add "parent", valid_589583
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
  var valid_589584 = query.getOrDefault("upload_protocol")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "upload_protocol", valid_589584
  var valid_589585 = query.getOrDefault("fields")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = nil)
  if valid_589585 != nil:
    section.add "fields", valid_589585
  var valid_589586 = query.getOrDefault("pageToken")
  valid_589586 = validateParameter(valid_589586, JString, required = false,
                                 default = nil)
  if valid_589586 != nil:
    section.add "pageToken", valid_589586
  var valid_589587 = query.getOrDefault("quotaUser")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = nil)
  if valid_589587 != nil:
    section.add "quotaUser", valid_589587
  var valid_589588 = query.getOrDefault("alt")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = newJString("json"))
  if valid_589588 != nil:
    section.add "alt", valid_589588
  var valid_589589 = query.getOrDefault("oauth_token")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "oauth_token", valid_589589
  var valid_589590 = query.getOrDefault("callback")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = nil)
  if valid_589590 != nil:
    section.add "callback", valid_589590
  var valid_589591 = query.getOrDefault("access_token")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "access_token", valid_589591
  var valid_589592 = query.getOrDefault("uploadType")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "uploadType", valid_589592
  var valid_589593 = query.getOrDefault("key")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "key", valid_589593
  var valid_589594 = query.getOrDefault("$.xgafv")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = newJString("1"))
  if valid_589594 != nil:
    section.add "$.xgafv", valid_589594
  var valid_589595 = query.getOrDefault("pageSize")
  valid_589595 = validateParameter(valid_589595, JInt, required = false, default = nil)
  if valid_589595 != nil:
    section.add "pageSize", valid_589595
  var valid_589596 = query.getOrDefault("prettyPrint")
  valid_589596 = validateParameter(valid_589596, JBool, required = false,
                                 default = newJBool(true))
  if valid_589596 != nil:
    section.add "prettyPrint", valid_589596
  var valid_589597 = query.getOrDefault("filter")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "filter", valid_589597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589598: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_589580;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the HL7v2 stores in the given dataset.
  ## 
  let valid = call_589598.validator(path, query, header, formData, body)
  let scheme = call_589598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589598.url(scheme.get, call_589598.host, call_589598.base,
                         call_589598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589598, url, valid)

proc call*(call_589599: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_589580;
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
  var path_589600 = newJObject()
  var query_589601 = newJObject()
  add(query_589601, "upload_protocol", newJString(uploadProtocol))
  add(query_589601, "fields", newJString(fields))
  add(query_589601, "pageToken", newJString(pageToken))
  add(query_589601, "quotaUser", newJString(quotaUser))
  add(query_589601, "alt", newJString(alt))
  add(query_589601, "oauth_token", newJString(oauthToken))
  add(query_589601, "callback", newJString(callback))
  add(query_589601, "access_token", newJString(accessToken))
  add(query_589601, "uploadType", newJString(uploadType))
  add(path_589600, "parent", newJString(parent))
  add(query_589601, "key", newJString(key))
  add(query_589601, "$.xgafv", newJString(Xgafv))
  add(query_589601, "pageSize", newJInt(pageSize))
  add(query_589601, "prettyPrint", newJBool(prettyPrint))
  add(query_589601, "filter", newJString(filter))
  result = call_589599.call(path_589600, query_589601, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresList_589580(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/hl7V2Stores",
    validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresList_589581,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresList_589582,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_589647 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_589649(
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

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_589648(
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
  var valid_589650 = path.getOrDefault("parent")
  valid_589650 = validateParameter(valid_589650, JString, required = true,
                                 default = nil)
  if valid_589650 != nil:
    section.add "parent", valid_589650
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
  var valid_589651 = query.getOrDefault("upload_protocol")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = nil)
  if valid_589651 != nil:
    section.add "upload_protocol", valid_589651
  var valid_589652 = query.getOrDefault("fields")
  valid_589652 = validateParameter(valid_589652, JString, required = false,
                                 default = nil)
  if valid_589652 != nil:
    section.add "fields", valid_589652
  var valid_589653 = query.getOrDefault("quotaUser")
  valid_589653 = validateParameter(valid_589653, JString, required = false,
                                 default = nil)
  if valid_589653 != nil:
    section.add "quotaUser", valid_589653
  var valid_589654 = query.getOrDefault("alt")
  valid_589654 = validateParameter(valid_589654, JString, required = false,
                                 default = newJString("json"))
  if valid_589654 != nil:
    section.add "alt", valid_589654
  var valid_589655 = query.getOrDefault("oauth_token")
  valid_589655 = validateParameter(valid_589655, JString, required = false,
                                 default = nil)
  if valid_589655 != nil:
    section.add "oauth_token", valid_589655
  var valid_589656 = query.getOrDefault("callback")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "callback", valid_589656
  var valid_589657 = query.getOrDefault("access_token")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "access_token", valid_589657
  var valid_589658 = query.getOrDefault("uploadType")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = nil)
  if valid_589658 != nil:
    section.add "uploadType", valid_589658
  var valid_589659 = query.getOrDefault("key")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = nil)
  if valid_589659 != nil:
    section.add "key", valid_589659
  var valid_589660 = query.getOrDefault("$.xgafv")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = newJString("1"))
  if valid_589660 != nil:
    section.add "$.xgafv", valid_589660
  var valid_589661 = query.getOrDefault("prettyPrint")
  valid_589661 = validateParameter(valid_589661, JBool, required = false,
                                 default = newJBool(true))
  if valid_589661 != nil:
    section.add "prettyPrint", valid_589661
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

proc call*(call_589663: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_589647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a message and sends a notification to the Cloud Pub/Sub topic. If
  ## configured, the MLLP adapter listens to messages created by this method and
  ## sends those back to the hospital. A successful response indicates the
  ## message has been persisted to storage and a Cloud Pub/Sub notification has
  ## been sent. Sending to the hospital by the MLLP adapter happens
  ## asynchronously.
  ## 
  let valid = call_589663.validator(path, query, header, formData, body)
  let scheme = call_589663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589663.url(scheme.get, call_589663.host, call_589663.base,
                         call_589663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589663, url, valid)

proc call*(call_589664: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_589647;
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
  var path_589665 = newJObject()
  var query_589666 = newJObject()
  var body_589667 = newJObject()
  add(query_589666, "upload_protocol", newJString(uploadProtocol))
  add(query_589666, "fields", newJString(fields))
  add(query_589666, "quotaUser", newJString(quotaUser))
  add(query_589666, "alt", newJString(alt))
  add(query_589666, "oauth_token", newJString(oauthToken))
  add(query_589666, "callback", newJString(callback))
  add(query_589666, "access_token", newJString(accessToken))
  add(query_589666, "uploadType", newJString(uploadType))
  add(path_589665, "parent", newJString(parent))
  add(query_589666, "key", newJString(key))
  add(query_589666, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589667 = body
  add(query_589666, "prettyPrint", newJBool(prettyPrint))
  result = call_589664.call(path_589665, query_589666, nil, nil, body_589667)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_589647(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_589648,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesCreate_589649,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_589624 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_589626(
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

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_589625(
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
  var valid_589627 = path.getOrDefault("parent")
  valid_589627 = validateParameter(valid_589627, JString, required = true,
                                 default = nil)
  if valid_589627 != nil:
    section.add "parent", valid_589627
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
  var valid_589628 = query.getOrDefault("upload_protocol")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "upload_protocol", valid_589628
  var valid_589629 = query.getOrDefault("fields")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "fields", valid_589629
  var valid_589630 = query.getOrDefault("pageToken")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "pageToken", valid_589630
  var valid_589631 = query.getOrDefault("quotaUser")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = nil)
  if valid_589631 != nil:
    section.add "quotaUser", valid_589631
  var valid_589632 = query.getOrDefault("alt")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = newJString("json"))
  if valid_589632 != nil:
    section.add "alt", valid_589632
  var valid_589633 = query.getOrDefault("oauth_token")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "oauth_token", valid_589633
  var valid_589634 = query.getOrDefault("callback")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = nil)
  if valid_589634 != nil:
    section.add "callback", valid_589634
  var valid_589635 = query.getOrDefault("access_token")
  valid_589635 = validateParameter(valid_589635, JString, required = false,
                                 default = nil)
  if valid_589635 != nil:
    section.add "access_token", valid_589635
  var valid_589636 = query.getOrDefault("uploadType")
  valid_589636 = validateParameter(valid_589636, JString, required = false,
                                 default = nil)
  if valid_589636 != nil:
    section.add "uploadType", valid_589636
  var valid_589637 = query.getOrDefault("orderBy")
  valid_589637 = validateParameter(valid_589637, JString, required = false,
                                 default = nil)
  if valid_589637 != nil:
    section.add "orderBy", valid_589637
  var valid_589638 = query.getOrDefault("key")
  valid_589638 = validateParameter(valid_589638, JString, required = false,
                                 default = nil)
  if valid_589638 != nil:
    section.add "key", valid_589638
  var valid_589639 = query.getOrDefault("$.xgafv")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = newJString("1"))
  if valid_589639 != nil:
    section.add "$.xgafv", valid_589639
  var valid_589640 = query.getOrDefault("pageSize")
  valid_589640 = validateParameter(valid_589640, JInt, required = false, default = nil)
  if valid_589640 != nil:
    section.add "pageSize", valid_589640
  var valid_589641 = query.getOrDefault("prettyPrint")
  valid_589641 = validateParameter(valid_589641, JBool, required = false,
                                 default = newJBool(true))
  if valid_589641 != nil:
    section.add "prettyPrint", valid_589641
  var valid_589642 = query.getOrDefault("filter")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "filter", valid_589642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589643: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_589624;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the messages in the given HL7v2 store with support for filtering.
  ## 
  ## Note: HL7v2 messages are indexed asynchronously, so there might be a slight
  ## delay between the time a message is created and when it can be found
  ## through a filter.
  ## 
  let valid = call_589643.validator(path, query, header, formData, body)
  let scheme = call_589643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589643.url(scheme.get, call_589643.host, call_589643.base,
                         call_589643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589643, url, valid)

proc call*(call_589644: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_589624;
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
  var path_589645 = newJObject()
  var query_589646 = newJObject()
  add(query_589646, "upload_protocol", newJString(uploadProtocol))
  add(query_589646, "fields", newJString(fields))
  add(query_589646, "pageToken", newJString(pageToken))
  add(query_589646, "quotaUser", newJString(quotaUser))
  add(query_589646, "alt", newJString(alt))
  add(query_589646, "oauth_token", newJString(oauthToken))
  add(query_589646, "callback", newJString(callback))
  add(query_589646, "access_token", newJString(accessToken))
  add(query_589646, "uploadType", newJString(uploadType))
  add(path_589645, "parent", newJString(parent))
  add(query_589646, "orderBy", newJString(orderBy))
  add(query_589646, "key", newJString(key))
  add(query_589646, "$.xgafv", newJString(Xgafv))
  add(query_589646, "pageSize", newJInt(pageSize))
  add(query_589646, "prettyPrint", newJBool(prettyPrint))
  add(query_589646, "filter", newJString(filter))
  result = call_589644.call(path_589645, query_589646, nil, nil, nil)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_589624(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesList",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/messages", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_589625,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesList_589626,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_589668 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_589670(
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

proc validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_589669(
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
  var valid_589671 = path.getOrDefault("parent")
  valid_589671 = validateParameter(valid_589671, JString, required = true,
                                 default = nil)
  if valid_589671 != nil:
    section.add "parent", valid_589671
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
  var valid_589672 = query.getOrDefault("upload_protocol")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "upload_protocol", valid_589672
  var valid_589673 = query.getOrDefault("fields")
  valid_589673 = validateParameter(valid_589673, JString, required = false,
                                 default = nil)
  if valid_589673 != nil:
    section.add "fields", valid_589673
  var valid_589674 = query.getOrDefault("quotaUser")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = nil)
  if valid_589674 != nil:
    section.add "quotaUser", valid_589674
  var valid_589675 = query.getOrDefault("alt")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = newJString("json"))
  if valid_589675 != nil:
    section.add "alt", valid_589675
  var valid_589676 = query.getOrDefault("oauth_token")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = nil)
  if valid_589676 != nil:
    section.add "oauth_token", valid_589676
  var valid_589677 = query.getOrDefault("callback")
  valid_589677 = validateParameter(valid_589677, JString, required = false,
                                 default = nil)
  if valid_589677 != nil:
    section.add "callback", valid_589677
  var valid_589678 = query.getOrDefault("access_token")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "access_token", valid_589678
  var valid_589679 = query.getOrDefault("uploadType")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = nil)
  if valid_589679 != nil:
    section.add "uploadType", valid_589679
  var valid_589680 = query.getOrDefault("key")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "key", valid_589680
  var valid_589681 = query.getOrDefault("$.xgafv")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = newJString("1"))
  if valid_589681 != nil:
    section.add "$.xgafv", valid_589681
  var valid_589682 = query.getOrDefault("prettyPrint")
  valid_589682 = validateParameter(valid_589682, JBool, required = false,
                                 default = newJBool(true))
  if valid_589682 != nil:
    section.add "prettyPrint", valid_589682
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

proc call*(call_589684: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_589668;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Ingests a new HL7v2 message from the hospital and sends a notification to
  ## the Cloud Pub/Sub topic. Return is an HL7v2 ACK message if the message was
  ## successfully stored. Otherwise an error is returned.  If an identical
  ## HL7v2 message is created twice only one resource is created on the server
  ## and no error is reported.
  ## 
  let valid = call_589684.validator(path, query, header, formData, body)
  let scheme = call_589684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589684.url(scheme.get, call_589684.host, call_589684.base,
                         call_589684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589684, url, valid)

proc call*(call_589685: Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_589668;
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
  var path_589686 = newJObject()
  var query_589687 = newJObject()
  var body_589688 = newJObject()
  add(query_589687, "upload_protocol", newJString(uploadProtocol))
  add(query_589687, "fields", newJString(fields))
  add(query_589687, "quotaUser", newJString(quotaUser))
  add(query_589687, "alt", newJString(alt))
  add(query_589687, "oauth_token", newJString(oauthToken))
  add(query_589687, "callback", newJString(callback))
  add(query_589687, "access_token", newJString(accessToken))
  add(query_589687, "uploadType", newJString(uploadType))
  add(path_589686, "parent", newJString(parent))
  add(query_589687, "key", newJString(key))
  add(query_589687, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589688 = body
  add(query_589687, "prettyPrint", newJBool(prettyPrint))
  result = call_589685.call(path_589686, query_589687, nil, nil, body_589688)

var healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest* = Call_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_589668(
    name: "healthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{parent}/messages:ingest", validator: validate_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_589669,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsHl7V2StoresMessagesIngest_589670,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_589689 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_589691(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_589690(
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
  var valid_589692 = path.getOrDefault("resource")
  valid_589692 = validateParameter(valid_589692, JString, required = true,
                                 default = nil)
  if valid_589692 != nil:
    section.add "resource", valid_589692
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
  var valid_589693 = query.getOrDefault("upload_protocol")
  valid_589693 = validateParameter(valid_589693, JString, required = false,
                                 default = nil)
  if valid_589693 != nil:
    section.add "upload_protocol", valid_589693
  var valid_589694 = query.getOrDefault("fields")
  valid_589694 = validateParameter(valid_589694, JString, required = false,
                                 default = nil)
  if valid_589694 != nil:
    section.add "fields", valid_589694
  var valid_589695 = query.getOrDefault("quotaUser")
  valid_589695 = validateParameter(valid_589695, JString, required = false,
                                 default = nil)
  if valid_589695 != nil:
    section.add "quotaUser", valid_589695
  var valid_589696 = query.getOrDefault("alt")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = newJString("json"))
  if valid_589696 != nil:
    section.add "alt", valid_589696
  var valid_589697 = query.getOrDefault("oauth_token")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = nil)
  if valid_589697 != nil:
    section.add "oauth_token", valid_589697
  var valid_589698 = query.getOrDefault("callback")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "callback", valid_589698
  var valid_589699 = query.getOrDefault("access_token")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = nil)
  if valid_589699 != nil:
    section.add "access_token", valid_589699
  var valid_589700 = query.getOrDefault("uploadType")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = nil)
  if valid_589700 != nil:
    section.add "uploadType", valid_589700
  var valid_589701 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589701 = validateParameter(valid_589701, JInt, required = false, default = nil)
  if valid_589701 != nil:
    section.add "options.requestedPolicyVersion", valid_589701
  var valid_589702 = query.getOrDefault("key")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "key", valid_589702
  var valid_589703 = query.getOrDefault("$.xgafv")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = newJString("1"))
  if valid_589703 != nil:
    section.add "$.xgafv", valid_589703
  var valid_589704 = query.getOrDefault("prettyPrint")
  valid_589704 = validateParameter(valid_589704, JBool, required = false,
                                 default = newJBool(true))
  if valid_589704 != nil:
    section.add "prettyPrint", valid_589704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589705: Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_589689;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_589705.validator(path, query, header, formData, body)
  let scheme = call_589705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589705.url(scheme.get, call_589705.host, call_589705.base,
                         call_589705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589705, url, valid)

proc call*(call_589706: Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_589689;
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
  var path_589707 = newJObject()
  var query_589708 = newJObject()
  add(query_589708, "upload_protocol", newJString(uploadProtocol))
  add(query_589708, "fields", newJString(fields))
  add(query_589708, "quotaUser", newJString(quotaUser))
  add(query_589708, "alt", newJString(alt))
  add(query_589708, "oauth_token", newJString(oauthToken))
  add(query_589708, "callback", newJString(callback))
  add(query_589708, "access_token", newJString(accessToken))
  add(query_589708, "uploadType", newJString(uploadType))
  add(query_589708, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589708, "key", newJString(key))
  add(query_589708, "$.xgafv", newJString(Xgafv))
  add(path_589707, "resource", newJString(resource))
  add(query_589708, "prettyPrint", newJBool(prettyPrint))
  result = call_589706.call(path_589707, query_589708, nil, nil, nil)

var healthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_589689(
    name: "healthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "healthcare.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_589690,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresGetIamPolicy_589691,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_589709 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_589711(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_589710(
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
  var valid_589712 = path.getOrDefault("resource")
  valid_589712 = validateParameter(valid_589712, JString, required = true,
                                 default = nil)
  if valid_589712 != nil:
    section.add "resource", valid_589712
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
  var valid_589713 = query.getOrDefault("upload_protocol")
  valid_589713 = validateParameter(valid_589713, JString, required = false,
                                 default = nil)
  if valid_589713 != nil:
    section.add "upload_protocol", valid_589713
  var valid_589714 = query.getOrDefault("fields")
  valid_589714 = validateParameter(valid_589714, JString, required = false,
                                 default = nil)
  if valid_589714 != nil:
    section.add "fields", valid_589714
  var valid_589715 = query.getOrDefault("quotaUser")
  valid_589715 = validateParameter(valid_589715, JString, required = false,
                                 default = nil)
  if valid_589715 != nil:
    section.add "quotaUser", valid_589715
  var valid_589716 = query.getOrDefault("alt")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = newJString("json"))
  if valid_589716 != nil:
    section.add "alt", valid_589716
  var valid_589717 = query.getOrDefault("oauth_token")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = nil)
  if valid_589717 != nil:
    section.add "oauth_token", valid_589717
  var valid_589718 = query.getOrDefault("callback")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "callback", valid_589718
  var valid_589719 = query.getOrDefault("access_token")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = nil)
  if valid_589719 != nil:
    section.add "access_token", valid_589719
  var valid_589720 = query.getOrDefault("uploadType")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "uploadType", valid_589720
  var valid_589721 = query.getOrDefault("key")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "key", valid_589721
  var valid_589722 = query.getOrDefault("$.xgafv")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = newJString("1"))
  if valid_589722 != nil:
    section.add "$.xgafv", valid_589722
  var valid_589723 = query.getOrDefault("prettyPrint")
  valid_589723 = validateParameter(valid_589723, JBool, required = false,
                                 default = newJBool(true))
  if valid_589723 != nil:
    section.add "prettyPrint", valid_589723
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

proc call*(call_589725: Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_589709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589725.validator(path, query, header, formData, body)
  let scheme = call_589725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589725.url(scheme.get, call_589725.host, call_589725.base,
                         call_589725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589725, url, valid)

proc call*(call_589726: Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_589709;
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
  var path_589727 = newJObject()
  var query_589728 = newJObject()
  var body_589729 = newJObject()
  add(query_589728, "upload_protocol", newJString(uploadProtocol))
  add(query_589728, "fields", newJString(fields))
  add(query_589728, "quotaUser", newJString(quotaUser))
  add(query_589728, "alt", newJString(alt))
  add(query_589728, "oauth_token", newJString(oauthToken))
  add(query_589728, "callback", newJString(callback))
  add(query_589728, "access_token", newJString(accessToken))
  add(query_589728, "uploadType", newJString(uploadType))
  add(query_589728, "key", newJString(key))
  add(query_589728, "$.xgafv", newJString(Xgafv))
  add(path_589727, "resource", newJString(resource))
  if body != nil:
    body_589729 = body
  add(query_589728, "prettyPrint", newJBool(prettyPrint))
  result = call_589726.call(path_589727, query_589728, nil, nil, body_589729)

var healthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy* = Call_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_589709(
    name: "healthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_589710,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsFhirStoresSetIamPolicy_589711,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_589730 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_589732(
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

proc validate_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_589731(
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
  var valid_589733 = path.getOrDefault("resource")
  valid_589733 = validateParameter(valid_589733, JString, required = true,
                                 default = nil)
  if valid_589733 != nil:
    section.add "resource", valid_589733
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
  var valid_589734 = query.getOrDefault("upload_protocol")
  valid_589734 = validateParameter(valid_589734, JString, required = false,
                                 default = nil)
  if valid_589734 != nil:
    section.add "upload_protocol", valid_589734
  var valid_589735 = query.getOrDefault("fields")
  valid_589735 = validateParameter(valid_589735, JString, required = false,
                                 default = nil)
  if valid_589735 != nil:
    section.add "fields", valid_589735
  var valid_589736 = query.getOrDefault("quotaUser")
  valid_589736 = validateParameter(valid_589736, JString, required = false,
                                 default = nil)
  if valid_589736 != nil:
    section.add "quotaUser", valid_589736
  var valid_589737 = query.getOrDefault("alt")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = newJString("json"))
  if valid_589737 != nil:
    section.add "alt", valid_589737
  var valid_589738 = query.getOrDefault("oauth_token")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = nil)
  if valid_589738 != nil:
    section.add "oauth_token", valid_589738
  var valid_589739 = query.getOrDefault("callback")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = nil)
  if valid_589739 != nil:
    section.add "callback", valid_589739
  var valid_589740 = query.getOrDefault("access_token")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = nil)
  if valid_589740 != nil:
    section.add "access_token", valid_589740
  var valid_589741 = query.getOrDefault("uploadType")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "uploadType", valid_589741
  var valid_589742 = query.getOrDefault("key")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "key", valid_589742
  var valid_589743 = query.getOrDefault("$.xgafv")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = newJString("1"))
  if valid_589743 != nil:
    section.add "$.xgafv", valid_589743
  var valid_589744 = query.getOrDefault("prettyPrint")
  valid_589744 = validateParameter(valid_589744, JBool, required = false,
                                 default = newJBool(true))
  if valid_589744 != nil:
    section.add "prettyPrint", valid_589744
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

proc call*(call_589746: Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_589730;
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
  let valid = call_589746.validator(path, query, header, formData, body)
  let scheme = call_589746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589746.url(scheme.get, call_589746.host, call_589746.base,
                         call_589746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589746, url, valid)

proc call*(call_589747: Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_589730;
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
  var path_589748 = newJObject()
  var query_589749 = newJObject()
  var body_589750 = newJObject()
  add(query_589749, "upload_protocol", newJString(uploadProtocol))
  add(query_589749, "fields", newJString(fields))
  add(query_589749, "quotaUser", newJString(quotaUser))
  add(query_589749, "alt", newJString(alt))
  add(query_589749, "oauth_token", newJString(oauthToken))
  add(query_589749, "callback", newJString(callback))
  add(query_589749, "access_token", newJString(accessToken))
  add(query_589749, "uploadType", newJString(uploadType))
  add(query_589749, "key", newJString(key))
  add(query_589749, "$.xgafv", newJString(Xgafv))
  add(path_589748, "resource", newJString(resource))
  if body != nil:
    body_589750 = body
  add(query_589749, "prettyPrint", newJBool(prettyPrint))
  result = call_589747.call(path_589748, query_589749, nil, nil, body_589750)

var healthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions* = Call_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_589730(
    name: "healthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions", validator: validate_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_589731,
    base: "/",
    url: url_HealthcareProjectsLocationsDatasetsFhirStoresTestIamPermissions_589732,
    schemes: {Scheme.Https})
type
  Call_HealthcareProjectsLocationsDatasetsDeidentify_589751 = ref object of OpenApiRestCall_588450
proc url_HealthcareProjectsLocationsDatasetsDeidentify_589753(protocol: Scheme;
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

proc validate_HealthcareProjectsLocationsDatasetsDeidentify_589752(
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
  var valid_589754 = path.getOrDefault("sourceDataset")
  valid_589754 = validateParameter(valid_589754, JString, required = true,
                                 default = nil)
  if valid_589754 != nil:
    section.add "sourceDataset", valid_589754
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
  var valid_589755 = query.getOrDefault("upload_protocol")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = nil)
  if valid_589755 != nil:
    section.add "upload_protocol", valid_589755
  var valid_589756 = query.getOrDefault("fields")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "fields", valid_589756
  var valid_589757 = query.getOrDefault("quotaUser")
  valid_589757 = validateParameter(valid_589757, JString, required = false,
                                 default = nil)
  if valid_589757 != nil:
    section.add "quotaUser", valid_589757
  var valid_589758 = query.getOrDefault("alt")
  valid_589758 = validateParameter(valid_589758, JString, required = false,
                                 default = newJString("json"))
  if valid_589758 != nil:
    section.add "alt", valid_589758
  var valid_589759 = query.getOrDefault("oauth_token")
  valid_589759 = validateParameter(valid_589759, JString, required = false,
                                 default = nil)
  if valid_589759 != nil:
    section.add "oauth_token", valid_589759
  var valid_589760 = query.getOrDefault("callback")
  valid_589760 = validateParameter(valid_589760, JString, required = false,
                                 default = nil)
  if valid_589760 != nil:
    section.add "callback", valid_589760
  var valid_589761 = query.getOrDefault("access_token")
  valid_589761 = validateParameter(valid_589761, JString, required = false,
                                 default = nil)
  if valid_589761 != nil:
    section.add "access_token", valid_589761
  var valid_589762 = query.getOrDefault("uploadType")
  valid_589762 = validateParameter(valid_589762, JString, required = false,
                                 default = nil)
  if valid_589762 != nil:
    section.add "uploadType", valid_589762
  var valid_589763 = query.getOrDefault("key")
  valid_589763 = validateParameter(valid_589763, JString, required = false,
                                 default = nil)
  if valid_589763 != nil:
    section.add "key", valid_589763
  var valid_589764 = query.getOrDefault("$.xgafv")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = newJString("1"))
  if valid_589764 != nil:
    section.add "$.xgafv", valid_589764
  var valid_589765 = query.getOrDefault("prettyPrint")
  valid_589765 = validateParameter(valid_589765, JBool, required = false,
                                 default = newJBool(true))
  if valid_589765 != nil:
    section.add "prettyPrint", valid_589765
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

proc call*(call_589767: Call_HealthcareProjectsLocationsDatasetsDeidentify_589751;
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
  let valid = call_589767.validator(path, query, header, formData, body)
  let scheme = call_589767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589767.url(scheme.get, call_589767.host, call_589767.base,
                         call_589767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589767, url, valid)

proc call*(call_589768: Call_HealthcareProjectsLocationsDatasetsDeidentify_589751;
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
  var path_589769 = newJObject()
  var query_589770 = newJObject()
  var body_589771 = newJObject()
  add(query_589770, "upload_protocol", newJString(uploadProtocol))
  add(query_589770, "fields", newJString(fields))
  add(query_589770, "quotaUser", newJString(quotaUser))
  add(query_589770, "alt", newJString(alt))
  add(query_589770, "oauth_token", newJString(oauthToken))
  add(query_589770, "callback", newJString(callback))
  add(query_589770, "access_token", newJString(accessToken))
  add(query_589770, "uploadType", newJString(uploadType))
  add(query_589770, "key", newJString(key))
  add(query_589770, "$.xgafv", newJString(Xgafv))
  add(path_589769, "sourceDataset", newJString(sourceDataset))
  if body != nil:
    body_589771 = body
  add(query_589770, "prettyPrint", newJBool(prettyPrint))
  result = call_589768.call(path_589769, query_589770, nil, nil, body_589771)

var healthcareProjectsLocationsDatasetsDeidentify* = Call_HealthcareProjectsLocationsDatasetsDeidentify_589751(
    name: "healthcareProjectsLocationsDatasetsDeidentify",
    meth: HttpMethod.HttpPost, host: "healthcare.googleapis.com",
    route: "/v1beta1/{sourceDataset}:deidentify",
    validator: validate_HealthcareProjectsLocationsDatasetsDeidentify_589752,
    base: "/", url: url_HealthcareProjectsLocationsDatasetsDeidentify_589753,
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
