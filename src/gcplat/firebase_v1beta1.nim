
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Firebase Management
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Firebase Management API enables programmatic setup and management of Firebase projects, including a project's Firebase resources and Firebase apps.
## 
## https://firebase.google.com
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
  gcpServiceName = "firebase"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebaseAvailableProjectsList_593677 = ref object of OpenApiRestCall_593408
proc url_FirebaseAvailableProjectsList_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FirebaseAvailableProjectsList_593678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of [Google Cloud Platform (GCP) `Projects`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects)
  ## that are available to have Firebase resources added to them.
  ## <br>
  ## <br>A GCP `Project` will only be returned if:
  ## <ol>
  ##   <li><p>The caller has sufficient
  ##          [Google IAM](https://cloud.google.com/iam) permissions to call
  ##          AddFirebase.</p></li>
  ##   <li><p>The GCP `Project` is not already a FirebaseProject.</p></li>
  ##   <li><p>The GCP `Project` is not in an Organization which has policies
  ##          that prevent Firebase resources from being added.</p></li>
  ## </ol>
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
  ##            : Token returned from a previous call to `ListAvailableProjects`
  ## indicating where in the set of GCP `Projects` to resume listing.
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
  ##           : The maximum number of GCP `Projects` to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
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
  var valid_593793 = query.getOrDefault("pageToken")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "pageToken", valid_593793
  var valid_593794 = query.getOrDefault("quotaUser")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "quotaUser", valid_593794
  var valid_593808 = query.getOrDefault("alt")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = newJString("json"))
  if valid_593808 != nil:
    section.add "alt", valid_593808
  var valid_593809 = query.getOrDefault("oauth_token")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "oauth_token", valid_593809
  var valid_593810 = query.getOrDefault("callback")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "callback", valid_593810
  var valid_593811 = query.getOrDefault("access_token")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "access_token", valid_593811
  var valid_593812 = query.getOrDefault("uploadType")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "uploadType", valid_593812
  var valid_593813 = query.getOrDefault("key")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "key", valid_593813
  var valid_593814 = query.getOrDefault("$.xgafv")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = newJString("1"))
  if valid_593814 != nil:
    section.add "$.xgafv", valid_593814
  var valid_593815 = query.getOrDefault("pageSize")
  valid_593815 = validateParameter(valid_593815, JInt, required = false, default = nil)
  if valid_593815 != nil:
    section.add "pageSize", valid_593815
  var valid_593816 = query.getOrDefault("prettyPrint")
  valid_593816 = validateParameter(valid_593816, JBool, required = false,
                                 default = newJBool(true))
  if valid_593816 != nil:
    section.add "prettyPrint", valid_593816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593839: Call_FirebaseAvailableProjectsList_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of [Google Cloud Platform (GCP) `Projects`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects)
  ## that are available to have Firebase resources added to them.
  ## <br>
  ## <br>A GCP `Project` will only be returned if:
  ## <ol>
  ##   <li><p>The caller has sufficient
  ##          [Google IAM](https://cloud.google.com/iam) permissions to call
  ##          AddFirebase.</p></li>
  ##   <li><p>The GCP `Project` is not already a FirebaseProject.</p></li>
  ##   <li><p>The GCP `Project` is not in an Organization which has policies
  ##          that prevent Firebase resources from being added.</p></li>
  ## </ol>
  ## 
  let valid = call_593839.validator(path, query, header, formData, body)
  let scheme = call_593839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593839.url(scheme.get, call_593839.host, call_593839.base,
                         call_593839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593839, url, valid)

proc call*(call_593910: Call_FirebaseAvailableProjectsList_593677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## firebaseAvailableProjectsList
  ## Returns a list of [Google Cloud Platform (GCP) `Projects`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects)
  ## that are available to have Firebase resources added to them.
  ## <br>
  ## <br>A GCP `Project` will only be returned if:
  ## <ol>
  ##   <li><p>The caller has sufficient
  ##          [Google IAM](https://cloud.google.com/iam) permissions to call
  ##          AddFirebase.</p></li>
  ##   <li><p>The GCP `Project` is not already a FirebaseProject.</p></li>
  ##   <li><p>The GCP `Project` is not in an Organization which has policies
  ##          that prevent Firebase resources from being added.</p></li>
  ## </ol>
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListAvailableProjects`
  ## indicating where in the set of GCP `Projects` to resume listing.
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
  ##   pageSize: int
  ##           : The maximum number of GCP `Projects` to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593911 = newJObject()
  add(query_593911, "upload_protocol", newJString(uploadProtocol))
  add(query_593911, "fields", newJString(fields))
  add(query_593911, "pageToken", newJString(pageToken))
  add(query_593911, "quotaUser", newJString(quotaUser))
  add(query_593911, "alt", newJString(alt))
  add(query_593911, "oauth_token", newJString(oauthToken))
  add(query_593911, "callback", newJString(callback))
  add(query_593911, "access_token", newJString(accessToken))
  add(query_593911, "uploadType", newJString(uploadType))
  add(query_593911, "key", newJString(key))
  add(query_593911, "$.xgafv", newJString(Xgafv))
  add(query_593911, "pageSize", newJInt(pageSize))
  add(query_593911, "prettyPrint", newJBool(prettyPrint))
  result = call_593910.call(nil, query_593911, nil, nil, nil)

var firebaseAvailableProjectsList* = Call_FirebaseAvailableProjectsList_593677(
    name: "firebaseAvailableProjectsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/availableProjects",
    validator: validate_FirebaseAvailableProjectsList_593678, base: "/",
    url: url_FirebaseAvailableProjectsList_593679, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsList_593951 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsList_593953(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FirebaseProjectsList_593952(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each FirebaseProject accessible to the caller.
  ## <br>
  ## <br>The elements are returned in no particular order, but they will be a
  ## consistent view of the Projects when additional requests are made with a
  ## `pageToken`.
  ## <br>
  ## <br>This method is eventually consistent with Project mutations, which
  ## means newly provisioned Projects and recent modifications to existing
  ## Projects might not be reflected in the set of Projects. The list will
  ## include only ACTIVE Projects.
  ## <br>
  ## <br>Use
  ## GetFirebaseProject
  ## for consistent reads as well as for additional Project details.
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
  ##            : Token returned from a previous call to `ListFirebaseProjects` indicating
  ## where in the set of Projects to resume listing.
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
  ##           : The maximum number of Projects to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
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
  var valid_593963 = query.getOrDefault("key")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "key", valid_593963
  var valid_593964 = query.getOrDefault("$.xgafv")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = newJString("1"))
  if valid_593964 != nil:
    section.add "$.xgafv", valid_593964
  var valid_593965 = query.getOrDefault("pageSize")
  valid_593965 = validateParameter(valid_593965, JInt, required = false, default = nil)
  if valid_593965 != nil:
    section.add "pageSize", valid_593965
  var valid_593966 = query.getOrDefault("prettyPrint")
  valid_593966 = validateParameter(valid_593966, JBool, required = false,
                                 default = newJBool(true))
  if valid_593966 != nil:
    section.add "prettyPrint", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_FirebaseProjectsList_593951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each FirebaseProject accessible to the caller.
  ## <br>
  ## <br>The elements are returned in no particular order, but they will be a
  ## consistent view of the Projects when additional requests are made with a
  ## `pageToken`.
  ## <br>
  ## <br>This method is eventually consistent with Project mutations, which
  ## means newly provisioned Projects and recent modifications to existing
  ## Projects might not be reflected in the set of Projects. The list will
  ## include only ACTIVE Projects.
  ## <br>
  ## <br>Use
  ## GetFirebaseProject
  ## for consistent reads as well as for additional Project details.
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_FirebaseProjectsList_593951;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## firebaseProjectsList
  ## Lists each FirebaseProject accessible to the caller.
  ## <br>
  ## <br>The elements are returned in no particular order, but they will be a
  ## consistent view of the Projects when additional requests are made with a
  ## `pageToken`.
  ## <br>
  ## <br>This method is eventually consistent with Project mutations, which
  ## means newly provisioned Projects and recent modifications to existing
  ## Projects might not be reflected in the set of Projects. The list will
  ## include only ACTIVE Projects.
  ## <br>
  ## <br>Use
  ## GetFirebaseProject
  ## for consistent reads as well as for additional Project details.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListFirebaseProjects` indicating
  ## where in the set of Projects to resume listing.
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
  ##   pageSize: int
  ##           : The maximum number of Projects to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593969 = newJObject()
  add(query_593969, "upload_protocol", newJString(uploadProtocol))
  add(query_593969, "fields", newJString(fields))
  add(query_593969, "pageToken", newJString(pageToken))
  add(query_593969, "quotaUser", newJString(quotaUser))
  add(query_593969, "alt", newJString(alt))
  add(query_593969, "oauth_token", newJString(oauthToken))
  add(query_593969, "callback", newJString(callback))
  add(query_593969, "access_token", newJString(accessToken))
  add(query_593969, "uploadType", newJString(uploadType))
  add(query_593969, "key", newJString(key))
  add(query_593969, "$.xgafv", newJString(Xgafv))
  add(query_593969, "pageSize", newJInt(pageSize))
  add(query_593969, "prettyPrint", newJBool(prettyPrint))
  result = call_593968.call(nil, query_593969, nil, nil, nil)

var firebaseProjectsList* = Call_FirebaseProjectsList_593951(
    name: "firebaseProjectsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/projects",
    validator: validate_FirebaseProjectsList_593952, base: "/",
    url: url_FirebaseProjectsList_593953, schemes: {Scheme.Https})
type
  Call_FirebaseOperationsGet_593970 = ref object of OpenApiRestCall_593408
proc url_FirebaseOperationsGet_593972(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseOperationsGet_593971(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593987 = path.getOrDefault("name")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "name", valid_593987
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
  var valid_593988 = query.getOrDefault("upload_protocol")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "upload_protocol", valid_593988
  var valid_593989 = query.getOrDefault("fields")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "fields", valid_593989
  var valid_593990 = query.getOrDefault("quotaUser")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "quotaUser", valid_593990
  var valid_593991 = query.getOrDefault("alt")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("json"))
  if valid_593991 != nil:
    section.add "alt", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("callback")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "callback", valid_593993
  var valid_593994 = query.getOrDefault("access_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "access_token", valid_593994
  var valid_593995 = query.getOrDefault("uploadType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "uploadType", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("$.xgafv")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("1"))
  if valid_593997 != nil:
    section.add "$.xgafv", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_FirebaseOperationsGet_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_FirebaseOperationsGet_593970; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firebaseOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(query_594002, "upload_protocol", newJString(uploadProtocol))
  add(query_594002, "fields", newJString(fields))
  add(query_594002, "quotaUser", newJString(quotaUser))
  add(path_594001, "name", newJString(name))
  add(query_594002, "alt", newJString(alt))
  add(query_594002, "oauth_token", newJString(oauthToken))
  add(query_594002, "callback", newJString(callback))
  add(query_594002, "access_token", newJString(accessToken))
  add(query_594002, "uploadType", newJString(uploadType))
  add(query_594002, "key", newJString(key))
  add(query_594002, "$.xgafv", newJString(Xgafv))
  add(query_594002, "prettyPrint", newJBool(prettyPrint))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var firebaseOperationsGet* = Call_FirebaseOperationsGet_593970(
    name: "firebaseOperationsGet", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseOperationsGet_593971, base: "/",
    url: url_FirebaseOperationsGet_593972, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsPatch_594022 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsIosAppsPatch_594024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsIosAppsPatch_594023(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The fully qualified resource name of the App, in the format:
  ## <br><code>projects/<var>projectId</var>/iosApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594025 = path.getOrDefault("name")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "name", valid_594025
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
  ##             : Specifies which fields to update.
  ## <br>Note that the fields `name`, `appId`, `projectId`, and `bundleId`
  ## are all immutable.
  section = newJObject()
  var valid_594026 = query.getOrDefault("upload_protocol")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "upload_protocol", valid_594026
  var valid_594027 = query.getOrDefault("fields")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "fields", valid_594027
  var valid_594028 = query.getOrDefault("quotaUser")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "quotaUser", valid_594028
  var valid_594029 = query.getOrDefault("alt")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = newJString("json"))
  if valid_594029 != nil:
    section.add "alt", valid_594029
  var valid_594030 = query.getOrDefault("oauth_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "oauth_token", valid_594030
  var valid_594031 = query.getOrDefault("callback")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "callback", valid_594031
  var valid_594032 = query.getOrDefault("access_token")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "access_token", valid_594032
  var valid_594033 = query.getOrDefault("uploadType")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "uploadType", valid_594033
  var valid_594034 = query.getOrDefault("key")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "key", valid_594034
  var valid_594035 = query.getOrDefault("$.xgafv")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("1"))
  if valid_594035 != nil:
    section.add "$.xgafv", valid_594035
  var valid_594036 = query.getOrDefault("prettyPrint")
  valid_594036 = validateParameter(valid_594036, JBool, required = false,
                                 default = newJBool(true))
  if valid_594036 != nil:
    section.add "prettyPrint", valid_594036
  var valid_594037 = query.getOrDefault("updateMask")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "updateMask", valid_594037
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

proc call*(call_594039: Call_FirebaseProjectsIosAppsPatch_594022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_FirebaseProjectsIosAppsPatch_594022; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## firebaseProjectsIosAppsPatch
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The fully qualified resource name of the App, in the format:
  ## <br><code>projects/<var>projectId</var>/iosApps/<var>appId</var></code>
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
  ##             : Specifies which fields to update.
  ## <br>Note that the fields `name`, `appId`, `projectId`, and `bundleId`
  ## are all immutable.
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  var body_594043 = newJObject()
  add(query_594042, "upload_protocol", newJString(uploadProtocol))
  add(query_594042, "fields", newJString(fields))
  add(query_594042, "quotaUser", newJString(quotaUser))
  add(path_594041, "name", newJString(name))
  add(query_594042, "alt", newJString(alt))
  add(query_594042, "oauth_token", newJString(oauthToken))
  add(query_594042, "callback", newJString(callback))
  add(query_594042, "access_token", newJString(accessToken))
  add(query_594042, "uploadType", newJString(uploadType))
  add(query_594042, "key", newJString(key))
  add(query_594042, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594043 = body
  add(query_594042, "prettyPrint", newJBool(prettyPrint))
  add(query_594042, "updateMask", newJString(updateMask))
  result = call_594040.call(path_594041, query_594042, nil, nil, body_594043)

var firebaseProjectsIosAppsPatch* = Call_FirebaseProjectsIosAppsPatch_594022(
    name: "firebaseProjectsIosAppsPatch", meth: HttpMethod.HttpPatch,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseProjectsIosAppsPatch_594023, base: "/",
    url: url_FirebaseProjectsIosAppsPatch_594024, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaDelete_594003 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsAndroidAppsShaDelete_594005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsShaDelete_594004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a SHA certificate from the specified AndroidApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The fully qualified resource name of the `sha-key`, in the format:
  ## 
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var>/sha/<var>shaId</var></code>
  ## <br>You can obtain the full name from the response of
  ## [`ListShaCertificates`](../projects.androidApps.sha/list) or the original
  ## [`CreateShaCertificate`](../projects.androidApps.sha/create).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594006 = path.getOrDefault("name")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "name", valid_594006
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
  var valid_594007 = query.getOrDefault("upload_protocol")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "upload_protocol", valid_594007
  var valid_594008 = query.getOrDefault("fields")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "fields", valid_594008
  var valid_594009 = query.getOrDefault("quotaUser")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "quotaUser", valid_594009
  var valid_594010 = query.getOrDefault("alt")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("json"))
  if valid_594010 != nil:
    section.add "alt", valid_594010
  var valid_594011 = query.getOrDefault("oauth_token")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "oauth_token", valid_594011
  var valid_594012 = query.getOrDefault("callback")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "callback", valid_594012
  var valid_594013 = query.getOrDefault("access_token")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "access_token", valid_594013
  var valid_594014 = query.getOrDefault("uploadType")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "uploadType", valid_594014
  var valid_594015 = query.getOrDefault("key")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "key", valid_594015
  var valid_594016 = query.getOrDefault("$.xgafv")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = newJString("1"))
  if valid_594016 != nil:
    section.add "$.xgafv", valid_594016
  var valid_594017 = query.getOrDefault("prettyPrint")
  valid_594017 = validateParameter(valid_594017, JBool, required = false,
                                 default = newJBool(true))
  if valid_594017 != nil:
    section.add "prettyPrint", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_FirebaseProjectsAndroidAppsShaDelete_594003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a SHA certificate from the specified AndroidApp.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_FirebaseProjectsAndroidAppsShaDelete_594003;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firebaseProjectsAndroidAppsShaDelete
  ## Removes a SHA certificate from the specified AndroidApp.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The fully qualified resource name of the `sha-key`, in the format:
  ## 
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var>/sha/<var>shaId</var></code>
  ## <br>You can obtain the full name from the response of
  ## [`ListShaCertificates`](../projects.androidApps.sha/list) or the original
  ## [`CreateShaCertificate`](../projects.androidApps.sha/create).
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
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  add(query_594021, "upload_protocol", newJString(uploadProtocol))
  add(query_594021, "fields", newJString(fields))
  add(query_594021, "quotaUser", newJString(quotaUser))
  add(path_594020, "name", newJString(name))
  add(query_594021, "alt", newJString(alt))
  add(query_594021, "oauth_token", newJString(oauthToken))
  add(query_594021, "callback", newJString(callback))
  add(query_594021, "access_token", newJString(accessToken))
  add(query_594021, "uploadType", newJString(uploadType))
  add(query_594021, "key", newJString(key))
  add(query_594021, "$.xgafv", newJString(Xgafv))
  add(query_594021, "prettyPrint", newJBool(prettyPrint))
  result = call_594019.call(path_594020, query_594021, nil, nil, nil)

var firebaseProjectsAndroidAppsShaDelete* = Call_FirebaseProjectsAndroidAppsShaDelete_594003(
    name: "firebaseProjectsAndroidAppsShaDelete", meth: HttpMethod.HttpDelete,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseProjectsAndroidAppsShaDelete_594004, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaDelete_594005, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsCreate_594065 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsAndroidAppsCreate_594067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/androidApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsCreate_594066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594068 = path.getOrDefault("parent")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "parent", valid_594068
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
  var valid_594069 = query.getOrDefault("upload_protocol")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "upload_protocol", valid_594069
  var valid_594070 = query.getOrDefault("fields")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "fields", valid_594070
  var valid_594071 = query.getOrDefault("quotaUser")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "quotaUser", valid_594071
  var valid_594072 = query.getOrDefault("alt")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("json"))
  if valid_594072 != nil:
    section.add "alt", valid_594072
  var valid_594073 = query.getOrDefault("oauth_token")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "oauth_token", valid_594073
  var valid_594074 = query.getOrDefault("callback")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "callback", valid_594074
  var valid_594075 = query.getOrDefault("access_token")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "access_token", valid_594075
  var valid_594076 = query.getOrDefault("uploadType")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "uploadType", valid_594076
  var valid_594077 = query.getOrDefault("key")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "key", valid_594077
  var valid_594078 = query.getOrDefault("$.xgafv")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("1"))
  if valid_594078 != nil:
    section.add "$.xgafv", valid_594078
  var valid_594079 = query.getOrDefault("prettyPrint")
  valid_594079 = validateParameter(valid_594079, JBool, required = false,
                                 default = newJBool(true))
  if valid_594079 != nil:
    section.add "prettyPrint", valid_594079
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

proc call*(call_594081: Call_FirebaseProjectsAndroidAppsCreate_594065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_FirebaseProjectsAndroidAppsCreate_594065;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebaseProjectsAndroidAppsCreate
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  var body_594085 = newJObject()
  add(query_594084, "upload_protocol", newJString(uploadProtocol))
  add(query_594084, "fields", newJString(fields))
  add(query_594084, "quotaUser", newJString(quotaUser))
  add(query_594084, "alt", newJString(alt))
  add(query_594084, "oauth_token", newJString(oauthToken))
  add(query_594084, "callback", newJString(callback))
  add(query_594084, "access_token", newJString(accessToken))
  add(query_594084, "uploadType", newJString(uploadType))
  add(path_594083, "parent", newJString(parent))
  add(query_594084, "key", newJString(key))
  add(query_594084, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594085 = body
  add(query_594084, "prettyPrint", newJBool(prettyPrint))
  result = call_594082.call(path_594083, query_594084, nil, nil, body_594085)

var firebaseProjectsAndroidAppsCreate* = Call_FirebaseProjectsAndroidAppsCreate_594065(
    name: "firebaseProjectsAndroidAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/androidApps",
    validator: validate_FirebaseProjectsAndroidAppsCreate_594066, base: "/",
    url: url_FirebaseProjectsAndroidAppsCreate_594067, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsList_594044 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsAndroidAppsList_594046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/androidApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsList_594045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594047 = path.getOrDefault("parent")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "parent", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListAndroidApps` indicating where
  ## in the set of Apps to resume listing.
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594048 = query.getOrDefault("upload_protocol")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "upload_protocol", valid_594048
  var valid_594049 = query.getOrDefault("fields")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "fields", valid_594049
  var valid_594050 = query.getOrDefault("pageToken")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "pageToken", valid_594050
  var valid_594051 = query.getOrDefault("quotaUser")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "quotaUser", valid_594051
  var valid_594052 = query.getOrDefault("alt")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = newJString("json"))
  if valid_594052 != nil:
    section.add "alt", valid_594052
  var valid_594053 = query.getOrDefault("oauth_token")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "oauth_token", valid_594053
  var valid_594054 = query.getOrDefault("callback")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "callback", valid_594054
  var valid_594055 = query.getOrDefault("access_token")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "access_token", valid_594055
  var valid_594056 = query.getOrDefault("uploadType")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "uploadType", valid_594056
  var valid_594057 = query.getOrDefault("key")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "key", valid_594057
  var valid_594058 = query.getOrDefault("$.xgafv")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = newJString("1"))
  if valid_594058 != nil:
    section.add "$.xgafv", valid_594058
  var valid_594059 = query.getOrDefault("pageSize")
  valid_594059 = validateParameter(valid_594059, JInt, required = false, default = nil)
  if valid_594059 != nil:
    section.add "pageSize", valid_594059
  var valid_594060 = query.getOrDefault("prettyPrint")
  valid_594060 = validateParameter(valid_594060, JBool, required = false,
                                 default = newJBool(true))
  if valid_594060 != nil:
    section.add "prettyPrint", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_FirebaseProjectsAndroidAppsList_594044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_FirebaseProjectsAndroidAppsList_594044;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## firebaseProjectsAndroidAppsList
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListAndroidApps` indicating where
  ## in the set of Apps to resume listing.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(query_594064, "upload_protocol", newJString(uploadProtocol))
  add(query_594064, "fields", newJString(fields))
  add(query_594064, "pageToken", newJString(pageToken))
  add(query_594064, "quotaUser", newJString(quotaUser))
  add(query_594064, "alt", newJString(alt))
  add(query_594064, "oauth_token", newJString(oauthToken))
  add(query_594064, "callback", newJString(callback))
  add(query_594064, "access_token", newJString(accessToken))
  add(query_594064, "uploadType", newJString(uploadType))
  add(path_594063, "parent", newJString(parent))
  add(query_594064, "key", newJString(key))
  add(query_594064, "$.xgafv", newJString(Xgafv))
  add(query_594064, "pageSize", newJInt(pageSize))
  add(query_594064, "prettyPrint", newJBool(prettyPrint))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var firebaseProjectsAndroidAppsList* = Call_FirebaseProjectsAndroidAppsList_594044(
    name: "firebaseProjectsAndroidAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/androidApps",
    validator: validate_FirebaseProjectsAndroidAppsList_594045, base: "/",
    url: url_FirebaseProjectsAndroidAppsList_594046, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAvailableLocationsList_594086 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsAvailableLocationsList_594088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/availableLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAvailableLocationsList_594087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of valid Google Cloud Platform (GCP) resource locations for
  ## the specified Project (including a FirebaseProject).
  ## <br>
  ## <br>The default GCP resource location of a project defines the geographical
  ## location where project resources, such as Cloud Firestore, will be
  ## provisioned by default.
  ## <br>
  ## <br>The returned list are the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>This call checks for any location restrictions for the specified
  ## Project and, thus, might return a subset of all possible GCP resource
  ## locations. To list all GCP resource locations (regardless of any
  ## restrictions), call the endpoint without specifying a `projectId` (that is,
  ## `/v1beta1/{parent=projects/-}/listAvailableLocations`).
  ## <br>
  ## <br>To call `ListAvailableLocations` with a specified project, a member
  ## must be at minimum a Viewer of the project. Calls without a specified
  ## project do not require any specific project permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The Project for which to list GCP resource locations, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## <br>If no project is specified (that is, `projects/-`), the returned list
  ## does not take into account org-specific or project-specific location
  ## restrictions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594089 = path.getOrDefault("parent")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "parent", valid_594089
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListAvailableLocations` indicating
  ## where in the list of locations to resume listing.
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
  ##           : The maximum number of locations to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594090 = query.getOrDefault("upload_protocol")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "upload_protocol", valid_594090
  var valid_594091 = query.getOrDefault("fields")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "fields", valid_594091
  var valid_594092 = query.getOrDefault("pageToken")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "pageToken", valid_594092
  var valid_594093 = query.getOrDefault("quotaUser")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "quotaUser", valid_594093
  var valid_594094 = query.getOrDefault("alt")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("json"))
  if valid_594094 != nil:
    section.add "alt", valid_594094
  var valid_594095 = query.getOrDefault("oauth_token")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "oauth_token", valid_594095
  var valid_594096 = query.getOrDefault("callback")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "callback", valid_594096
  var valid_594097 = query.getOrDefault("access_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "access_token", valid_594097
  var valid_594098 = query.getOrDefault("uploadType")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "uploadType", valid_594098
  var valid_594099 = query.getOrDefault("key")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "key", valid_594099
  var valid_594100 = query.getOrDefault("$.xgafv")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = newJString("1"))
  if valid_594100 != nil:
    section.add "$.xgafv", valid_594100
  var valid_594101 = query.getOrDefault("pageSize")
  valid_594101 = validateParameter(valid_594101, JInt, required = false, default = nil)
  if valid_594101 != nil:
    section.add "pageSize", valid_594101
  var valid_594102 = query.getOrDefault("prettyPrint")
  valid_594102 = validateParameter(valid_594102, JBool, required = false,
                                 default = newJBool(true))
  if valid_594102 != nil:
    section.add "prettyPrint", valid_594102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594103: Call_FirebaseProjectsAvailableLocationsList_594086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of valid Google Cloud Platform (GCP) resource locations for
  ## the specified Project (including a FirebaseProject).
  ## <br>
  ## <br>The default GCP resource location of a project defines the geographical
  ## location where project resources, such as Cloud Firestore, will be
  ## provisioned by default.
  ## <br>
  ## <br>The returned list are the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>This call checks for any location restrictions for the specified
  ## Project and, thus, might return a subset of all possible GCP resource
  ## locations. To list all GCP resource locations (regardless of any
  ## restrictions), call the endpoint without specifying a `projectId` (that is,
  ## `/v1beta1/{parent=projects/-}/listAvailableLocations`).
  ## <br>
  ## <br>To call `ListAvailableLocations` with a specified project, a member
  ## must be at minimum a Viewer of the project. Calls without a specified
  ## project do not require any specific project permissions.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_FirebaseProjectsAvailableLocationsList_594086;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## firebaseProjectsAvailableLocationsList
  ## Returns a list of valid Google Cloud Platform (GCP) resource locations for
  ## the specified Project (including a FirebaseProject).
  ## <br>
  ## <br>The default GCP resource location of a project defines the geographical
  ## location where project resources, such as Cloud Firestore, will be
  ## provisioned by default.
  ## <br>
  ## <br>The returned list are the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>This call checks for any location restrictions for the specified
  ## Project and, thus, might return a subset of all possible GCP resource
  ## locations. To list all GCP resource locations (regardless of any
  ## restrictions), call the endpoint without specifying a `projectId` (that is,
  ## `/v1beta1/{parent=projects/-}/listAvailableLocations`).
  ## <br>
  ## <br>To call `ListAvailableLocations` with a specified project, a member
  ## must be at minimum a Viewer of the project. Calls without a specified
  ## project do not require any specific project permissions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListAvailableLocations` indicating
  ## where in the list of locations to resume listing.
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
  ##         : The Project for which to list GCP resource locations, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## <br>If no project is specified (that is, `projects/-`), the returned list
  ## does not take into account org-specific or project-specific location
  ## restrictions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of locations to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594105 = newJObject()
  var query_594106 = newJObject()
  add(query_594106, "upload_protocol", newJString(uploadProtocol))
  add(query_594106, "fields", newJString(fields))
  add(query_594106, "pageToken", newJString(pageToken))
  add(query_594106, "quotaUser", newJString(quotaUser))
  add(query_594106, "alt", newJString(alt))
  add(query_594106, "oauth_token", newJString(oauthToken))
  add(query_594106, "callback", newJString(callback))
  add(query_594106, "access_token", newJString(accessToken))
  add(query_594106, "uploadType", newJString(uploadType))
  add(path_594105, "parent", newJString(parent))
  add(query_594106, "key", newJString(key))
  add(query_594106, "$.xgafv", newJString(Xgafv))
  add(query_594106, "pageSize", newJInt(pageSize))
  add(query_594106, "prettyPrint", newJBool(prettyPrint))
  result = call_594104.call(path_594105, query_594106, nil, nil, nil)

var firebaseProjectsAvailableLocationsList* = Call_FirebaseProjectsAvailableLocationsList_594086(
    name: "firebaseProjectsAvailableLocationsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}/availableLocations",
    validator: validate_FirebaseProjectsAvailableLocationsList_594087, base: "/",
    url: url_FirebaseProjectsAvailableLocationsList_594088,
    schemes: {Scheme.Https})
type
  Call_FirebaseProjectsDefaultLocationFinalize_594107 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsDefaultLocationFinalize_594109(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/defaultLocation:finalize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsDefaultLocationFinalize_594108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the default Google Cloud Platform (GCP) resource location for the
  ## specified FirebaseProject.
  ## <br>
  ## <br>This method creates an App Engine application with a
  ## [default Cloud Storage
  ## bucket](https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage#activating_a_cloud_storage_bucket),
  ## located in the specified
  ## [`location_id`](#body.request_body.FIELDS.location_id).
  ## This location must be one of the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>After the default GCP resource location is finalized, or if it was
  ## already set, it cannot be changed. The default GCP resource location for
  ## the specified FirebaseProject might already be set because either the
  ## GCP `Project` already has an App Engine application or
  ## `FinalizeDefaultLocation` was previously called with a specified
  ## `location_id`. Any new calls to `FinalizeDefaultLocation` with a
  ## <em>different</em> specified `location_id` will return a 409 error.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations),
  ## which can be used to track the provisioning process. The
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) type of
  ## the `Operation` is google.protobuf.Empty.
  ## <br>
  ## <br>The `Operation` can be polled by its `name` using
  ## GetOperation until `done` is
  ## true. When `done` is true, the `Operation` has either succeeded or failed.
  ## If the `Operation` has succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) will be
  ## set to a google.protobuf.Empty; if the `Operation` has failed, its
  ## `error` will be set to a google.rpc.Status. The `Operation` is
  ## automatically deleted after completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>All fields listed in the [request body](#request-body) are required.
  ## <br>
  ## <br>To call `FinalizeDefaultLocation`, a member must be an Owner
  ## of the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the Project for which the default GCP resource
  ## location will be set, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594110 = path.getOrDefault("parent")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "parent", valid_594110
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
  var valid_594111 = query.getOrDefault("upload_protocol")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "upload_protocol", valid_594111
  var valid_594112 = query.getOrDefault("fields")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "fields", valid_594112
  var valid_594113 = query.getOrDefault("quotaUser")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "quotaUser", valid_594113
  var valid_594114 = query.getOrDefault("alt")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = newJString("json"))
  if valid_594114 != nil:
    section.add "alt", valid_594114
  var valid_594115 = query.getOrDefault("oauth_token")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "oauth_token", valid_594115
  var valid_594116 = query.getOrDefault("callback")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "callback", valid_594116
  var valid_594117 = query.getOrDefault("access_token")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "access_token", valid_594117
  var valid_594118 = query.getOrDefault("uploadType")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "uploadType", valid_594118
  var valid_594119 = query.getOrDefault("key")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "key", valid_594119
  var valid_594120 = query.getOrDefault("$.xgafv")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = newJString("1"))
  if valid_594120 != nil:
    section.add "$.xgafv", valid_594120
  var valid_594121 = query.getOrDefault("prettyPrint")
  valid_594121 = validateParameter(valid_594121, JBool, required = false,
                                 default = newJBool(true))
  if valid_594121 != nil:
    section.add "prettyPrint", valid_594121
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

proc call*(call_594123: Call_FirebaseProjectsDefaultLocationFinalize_594107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the default Google Cloud Platform (GCP) resource location for the
  ## specified FirebaseProject.
  ## <br>
  ## <br>This method creates an App Engine application with a
  ## [default Cloud Storage
  ## bucket](https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage#activating_a_cloud_storage_bucket),
  ## located in the specified
  ## [`location_id`](#body.request_body.FIELDS.location_id).
  ## This location must be one of the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>After the default GCP resource location is finalized, or if it was
  ## already set, it cannot be changed. The default GCP resource location for
  ## the specified FirebaseProject might already be set because either the
  ## GCP `Project` already has an App Engine application or
  ## `FinalizeDefaultLocation` was previously called with a specified
  ## `location_id`. Any new calls to `FinalizeDefaultLocation` with a
  ## <em>different</em> specified `location_id` will return a 409 error.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations),
  ## which can be used to track the provisioning process. The
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) type of
  ## the `Operation` is google.protobuf.Empty.
  ## <br>
  ## <br>The `Operation` can be polled by its `name` using
  ## GetOperation until `done` is
  ## true. When `done` is true, the `Operation` has either succeeded or failed.
  ## If the `Operation` has succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) will be
  ## set to a google.protobuf.Empty; if the `Operation` has failed, its
  ## `error` will be set to a google.rpc.Status. The `Operation` is
  ## automatically deleted after completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>All fields listed in the [request body](#request-body) are required.
  ## <br>
  ## <br>To call `FinalizeDefaultLocation`, a member must be an Owner
  ## of the project.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_FirebaseProjectsDefaultLocationFinalize_594107;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebaseProjectsDefaultLocationFinalize
  ## Sets the default Google Cloud Platform (GCP) resource location for the
  ## specified FirebaseProject.
  ## <br>
  ## <br>This method creates an App Engine application with a
  ## [default Cloud Storage
  ## bucket](https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage#activating_a_cloud_storage_bucket),
  ## located in the specified
  ## [`location_id`](#body.request_body.FIELDS.location_id).
  ## This location must be one of the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>After the default GCP resource location is finalized, or if it was
  ## already set, it cannot be changed. The default GCP resource location for
  ## the specified FirebaseProject might already be set because either the
  ## GCP `Project` already has an App Engine application or
  ## `FinalizeDefaultLocation` was previously called with a specified
  ## `location_id`. Any new calls to `FinalizeDefaultLocation` with a
  ## <em>different</em> specified `location_id` will return a 409 error.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations),
  ## which can be used to track the provisioning process. The
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) type of
  ## the `Operation` is google.protobuf.Empty.
  ## <br>
  ## <br>The `Operation` can be polled by its `name` using
  ## GetOperation until `done` is
  ## true. When `done` is true, the `Operation` has either succeeded or failed.
  ## If the `Operation` has succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) will be
  ## set to a google.protobuf.Empty; if the `Operation` has failed, its
  ## `error` will be set to a google.rpc.Status. The `Operation` is
  ## automatically deleted after completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>All fields listed in the [request body](#request-body) are required.
  ## <br>
  ## <br>To call `FinalizeDefaultLocation`, a member must be an Owner
  ## of the project.
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
  ##         : The resource name of the Project for which the default GCP resource
  ## location will be set, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  var body_594127 = newJObject()
  add(query_594126, "upload_protocol", newJString(uploadProtocol))
  add(query_594126, "fields", newJString(fields))
  add(query_594126, "quotaUser", newJString(quotaUser))
  add(query_594126, "alt", newJString(alt))
  add(query_594126, "oauth_token", newJString(oauthToken))
  add(query_594126, "callback", newJString(callback))
  add(query_594126, "access_token", newJString(accessToken))
  add(query_594126, "uploadType", newJString(uploadType))
  add(path_594125, "parent", newJString(parent))
  add(query_594126, "key", newJString(key))
  add(query_594126, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594127 = body
  add(query_594126, "prettyPrint", newJBool(prettyPrint))
  result = call_594124.call(path_594125, query_594126, nil, nil, body_594127)

var firebaseProjectsDefaultLocationFinalize* = Call_FirebaseProjectsDefaultLocationFinalize_594107(
    name: "firebaseProjectsDefaultLocationFinalize", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}/defaultLocation:finalize",
    validator: validate_FirebaseProjectsDefaultLocationFinalize_594108, base: "/",
    url: url_FirebaseProjectsDefaultLocationFinalize_594109,
    schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsCreate_594149 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsIosAppsCreate_594151(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/iosApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsIosAppsCreate_594150(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594152 = path.getOrDefault("parent")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "parent", valid_594152
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
  var valid_594153 = query.getOrDefault("upload_protocol")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "upload_protocol", valid_594153
  var valid_594154 = query.getOrDefault("fields")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "fields", valid_594154
  var valid_594155 = query.getOrDefault("quotaUser")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "quotaUser", valid_594155
  var valid_594156 = query.getOrDefault("alt")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = newJString("json"))
  if valid_594156 != nil:
    section.add "alt", valid_594156
  var valid_594157 = query.getOrDefault("oauth_token")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "oauth_token", valid_594157
  var valid_594158 = query.getOrDefault("callback")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "callback", valid_594158
  var valid_594159 = query.getOrDefault("access_token")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "access_token", valid_594159
  var valid_594160 = query.getOrDefault("uploadType")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "uploadType", valid_594160
  var valid_594161 = query.getOrDefault("key")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "key", valid_594161
  var valid_594162 = query.getOrDefault("$.xgafv")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = newJString("1"))
  if valid_594162 != nil:
    section.add "$.xgafv", valid_594162
  var valid_594163 = query.getOrDefault("prettyPrint")
  valid_594163 = validateParameter(valid_594163, JBool, required = false,
                                 default = newJBool(true))
  if valid_594163 != nil:
    section.add "prettyPrint", valid_594163
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

proc call*(call_594165: Call_FirebaseProjectsIosAppsCreate_594149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_594165.validator(path, query, header, formData, body)
  let scheme = call_594165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594165.url(scheme.get, call_594165.host, call_594165.base,
                         call_594165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594165, url, valid)

proc call*(call_594166: Call_FirebaseProjectsIosAppsCreate_594149; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## firebaseProjectsIosAppsCreate
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594167 = newJObject()
  var query_594168 = newJObject()
  var body_594169 = newJObject()
  add(query_594168, "upload_protocol", newJString(uploadProtocol))
  add(query_594168, "fields", newJString(fields))
  add(query_594168, "quotaUser", newJString(quotaUser))
  add(query_594168, "alt", newJString(alt))
  add(query_594168, "oauth_token", newJString(oauthToken))
  add(query_594168, "callback", newJString(callback))
  add(query_594168, "access_token", newJString(accessToken))
  add(query_594168, "uploadType", newJString(uploadType))
  add(path_594167, "parent", newJString(parent))
  add(query_594168, "key", newJString(key))
  add(query_594168, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594169 = body
  add(query_594168, "prettyPrint", newJBool(prettyPrint))
  result = call_594166.call(path_594167, query_594168, nil, nil, body_594169)

var firebaseProjectsIosAppsCreate* = Call_FirebaseProjectsIosAppsCreate_594149(
    name: "firebaseProjectsIosAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/iosApps",
    validator: validate_FirebaseProjectsIosAppsCreate_594150, base: "/",
    url: url_FirebaseProjectsIosAppsCreate_594151, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsList_594128 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsIosAppsList_594130(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/iosApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsIosAppsList_594129(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594131 = path.getOrDefault("parent")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "parent", valid_594131
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListIosApps` indicating where in
  ## the set of Apps to resume listing.
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594132 = query.getOrDefault("upload_protocol")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "upload_protocol", valid_594132
  var valid_594133 = query.getOrDefault("fields")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "fields", valid_594133
  var valid_594134 = query.getOrDefault("pageToken")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "pageToken", valid_594134
  var valid_594135 = query.getOrDefault("quotaUser")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "quotaUser", valid_594135
  var valid_594136 = query.getOrDefault("alt")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = newJString("json"))
  if valid_594136 != nil:
    section.add "alt", valid_594136
  var valid_594137 = query.getOrDefault("oauth_token")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "oauth_token", valid_594137
  var valid_594138 = query.getOrDefault("callback")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "callback", valid_594138
  var valid_594139 = query.getOrDefault("access_token")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "access_token", valid_594139
  var valid_594140 = query.getOrDefault("uploadType")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "uploadType", valid_594140
  var valid_594141 = query.getOrDefault("key")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "key", valid_594141
  var valid_594142 = query.getOrDefault("$.xgafv")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = newJString("1"))
  if valid_594142 != nil:
    section.add "$.xgafv", valid_594142
  var valid_594143 = query.getOrDefault("pageSize")
  valid_594143 = validateParameter(valid_594143, JInt, required = false, default = nil)
  if valid_594143 != nil:
    section.add "pageSize", valid_594143
  var valid_594144 = query.getOrDefault("prettyPrint")
  valid_594144 = validateParameter(valid_594144, JBool, required = false,
                                 default = newJBool(true))
  if valid_594144 != nil:
    section.add "prettyPrint", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594145: Call_FirebaseProjectsIosAppsList_594128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_FirebaseProjectsIosAppsList_594128; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## firebaseProjectsIosAppsList
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListIosApps` indicating where in
  ## the set of Apps to resume listing.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594147 = newJObject()
  var query_594148 = newJObject()
  add(query_594148, "upload_protocol", newJString(uploadProtocol))
  add(query_594148, "fields", newJString(fields))
  add(query_594148, "pageToken", newJString(pageToken))
  add(query_594148, "quotaUser", newJString(quotaUser))
  add(query_594148, "alt", newJString(alt))
  add(query_594148, "oauth_token", newJString(oauthToken))
  add(query_594148, "callback", newJString(callback))
  add(query_594148, "access_token", newJString(accessToken))
  add(query_594148, "uploadType", newJString(uploadType))
  add(path_594147, "parent", newJString(parent))
  add(query_594148, "key", newJString(key))
  add(query_594148, "$.xgafv", newJString(Xgafv))
  add(query_594148, "pageSize", newJInt(pageSize))
  add(query_594148, "prettyPrint", newJBool(prettyPrint))
  result = call_594146.call(path_594147, query_594148, nil, nil, nil)

var firebaseProjectsIosAppsList* = Call_FirebaseProjectsIosAppsList_594128(
    name: "firebaseProjectsIosAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/iosApps",
    validator: validate_FirebaseProjectsIosAppsList_594129, base: "/",
    url: url_FirebaseProjectsIosAppsList_594130, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaCreate_594189 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsAndroidAppsShaCreate_594191(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sha")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsShaCreate_594190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a SHA certificate to the specified AndroidApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent App to which a SHA certificate will be added, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594192 = path.getOrDefault("parent")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "parent", valid_594192
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
  var valid_594193 = query.getOrDefault("upload_protocol")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "upload_protocol", valid_594193
  var valid_594194 = query.getOrDefault("fields")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "fields", valid_594194
  var valid_594195 = query.getOrDefault("quotaUser")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "quotaUser", valid_594195
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
  var valid_594203 = query.getOrDefault("prettyPrint")
  valid_594203 = validateParameter(valid_594203, JBool, required = false,
                                 default = newJBool(true))
  if valid_594203 != nil:
    section.add "prettyPrint", valid_594203
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

proc call*(call_594205: Call_FirebaseProjectsAndroidAppsShaCreate_594189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a SHA certificate to the specified AndroidApp.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_FirebaseProjectsAndroidAppsShaCreate_594189;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebaseProjectsAndroidAppsShaCreate
  ## Adds a SHA certificate to the specified AndroidApp.
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
  ##         : The parent App to which a SHA certificate will be added, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  var body_594209 = newJObject()
  add(query_594208, "upload_protocol", newJString(uploadProtocol))
  add(query_594208, "fields", newJString(fields))
  add(query_594208, "quotaUser", newJString(quotaUser))
  add(query_594208, "alt", newJString(alt))
  add(query_594208, "oauth_token", newJString(oauthToken))
  add(query_594208, "callback", newJString(callback))
  add(query_594208, "access_token", newJString(accessToken))
  add(query_594208, "uploadType", newJString(uploadType))
  add(path_594207, "parent", newJString(parent))
  add(query_594208, "key", newJString(key))
  add(query_594208, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594209 = body
  add(query_594208, "prettyPrint", newJBool(prettyPrint))
  result = call_594206.call(path_594207, query_594208, nil, nil, body_594209)

var firebaseProjectsAndroidAppsShaCreate* = Call_FirebaseProjectsAndroidAppsShaCreate_594189(
    name: "firebaseProjectsAndroidAppsShaCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/sha",
    validator: validate_FirebaseProjectsAndroidAppsShaCreate_594190, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaCreate_594191, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaList_594170 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsAndroidAppsShaList_594172(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sha")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsShaList_594171(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent App for which to list SHA certificates, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594173 = path.getOrDefault("parent")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "parent", valid_594173
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
  var valid_594174 = query.getOrDefault("upload_protocol")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "upload_protocol", valid_594174
  var valid_594175 = query.getOrDefault("fields")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "fields", valid_594175
  var valid_594176 = query.getOrDefault("quotaUser")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "quotaUser", valid_594176
  var valid_594177 = query.getOrDefault("alt")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = newJString("json"))
  if valid_594177 != nil:
    section.add "alt", valid_594177
  var valid_594178 = query.getOrDefault("oauth_token")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "oauth_token", valid_594178
  var valid_594179 = query.getOrDefault("callback")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "callback", valid_594179
  var valid_594180 = query.getOrDefault("access_token")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "access_token", valid_594180
  var valid_594181 = query.getOrDefault("uploadType")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "uploadType", valid_594181
  var valid_594182 = query.getOrDefault("key")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "key", valid_594182
  var valid_594183 = query.getOrDefault("$.xgafv")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = newJString("1"))
  if valid_594183 != nil:
    section.add "$.xgafv", valid_594183
  var valid_594184 = query.getOrDefault("prettyPrint")
  valid_594184 = validateParameter(valid_594184, JBool, required = false,
                                 default = newJBool(true))
  if valid_594184 != nil:
    section.add "prettyPrint", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_FirebaseProjectsAndroidAppsShaList_594170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_FirebaseProjectsAndroidAppsShaList_594170;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firebaseProjectsAndroidAppsShaList
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
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
  ##         : The parent App for which to list SHA certificates, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(query_594188, "upload_protocol", newJString(uploadProtocol))
  add(query_594188, "fields", newJString(fields))
  add(query_594188, "quotaUser", newJString(quotaUser))
  add(query_594188, "alt", newJString(alt))
  add(query_594188, "oauth_token", newJString(oauthToken))
  add(query_594188, "callback", newJString(callback))
  add(query_594188, "access_token", newJString(accessToken))
  add(query_594188, "uploadType", newJString(uploadType))
  add(path_594187, "parent", newJString(parent))
  add(query_594188, "key", newJString(key))
  add(query_594188, "$.xgafv", newJString(Xgafv))
  add(query_594188, "prettyPrint", newJBool(prettyPrint))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var firebaseProjectsAndroidAppsShaList* = Call_FirebaseProjectsAndroidAppsShaList_594170(
    name: "firebaseProjectsAndroidAppsShaList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/sha",
    validator: validate_FirebaseProjectsAndroidAppsShaList_594171, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaList_594172, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsWebAppsCreate_594231 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsWebAppsCreate_594233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsWebAppsCreate_594232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594234 = path.getOrDefault("parent")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "parent", valid_594234
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
  var valid_594235 = query.getOrDefault("upload_protocol")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "upload_protocol", valid_594235
  var valid_594236 = query.getOrDefault("fields")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "fields", valid_594236
  var valid_594237 = query.getOrDefault("quotaUser")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "quotaUser", valid_594237
  var valid_594238 = query.getOrDefault("alt")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = newJString("json"))
  if valid_594238 != nil:
    section.add "alt", valid_594238
  var valid_594239 = query.getOrDefault("oauth_token")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "oauth_token", valid_594239
  var valid_594240 = query.getOrDefault("callback")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "callback", valid_594240
  var valid_594241 = query.getOrDefault("access_token")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "access_token", valid_594241
  var valid_594242 = query.getOrDefault("uploadType")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "uploadType", valid_594242
  var valid_594243 = query.getOrDefault("key")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "key", valid_594243
  var valid_594244 = query.getOrDefault("$.xgafv")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = newJString("1"))
  if valid_594244 != nil:
    section.add "$.xgafv", valid_594244
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594247: Call_FirebaseProjectsWebAppsCreate_594231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_FirebaseProjectsWebAppsCreate_594231; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## firebaseProjectsWebAppsCreate
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594249 = newJObject()
  var query_594250 = newJObject()
  var body_594251 = newJObject()
  add(query_594250, "upload_protocol", newJString(uploadProtocol))
  add(query_594250, "fields", newJString(fields))
  add(query_594250, "quotaUser", newJString(quotaUser))
  add(query_594250, "alt", newJString(alt))
  add(query_594250, "oauth_token", newJString(oauthToken))
  add(query_594250, "callback", newJString(callback))
  add(query_594250, "access_token", newJString(accessToken))
  add(query_594250, "uploadType", newJString(uploadType))
  add(path_594249, "parent", newJString(parent))
  add(query_594250, "key", newJString(key))
  add(query_594250, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594251 = body
  add(query_594250, "prettyPrint", newJBool(prettyPrint))
  result = call_594248.call(path_594249, query_594250, nil, nil, body_594251)

var firebaseProjectsWebAppsCreate* = Call_FirebaseProjectsWebAppsCreate_594231(
    name: "firebaseProjectsWebAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/webApps",
    validator: validate_FirebaseProjectsWebAppsCreate_594232, base: "/",
    url: url_FirebaseProjectsWebAppsCreate_594233, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsWebAppsList_594210 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsWebAppsList_594212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsWebAppsList_594211(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594213 = path.getOrDefault("parent")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "parent", valid_594213
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListWebApps` indicating where in
  ## the set of Apps to resume listing.
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
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
  var valid_594216 = query.getOrDefault("pageToken")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "pageToken", valid_594216
  var valid_594217 = query.getOrDefault("quotaUser")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "quotaUser", valid_594217
  var valid_594218 = query.getOrDefault("alt")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = newJString("json"))
  if valid_594218 != nil:
    section.add "alt", valid_594218
  var valid_594219 = query.getOrDefault("oauth_token")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "oauth_token", valid_594219
  var valid_594220 = query.getOrDefault("callback")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "callback", valid_594220
  var valid_594221 = query.getOrDefault("access_token")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "access_token", valid_594221
  var valid_594222 = query.getOrDefault("uploadType")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "uploadType", valid_594222
  var valid_594223 = query.getOrDefault("key")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "key", valid_594223
  var valid_594224 = query.getOrDefault("$.xgafv")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = newJString("1"))
  if valid_594224 != nil:
    section.add "$.xgafv", valid_594224
  var valid_594225 = query.getOrDefault("pageSize")
  valid_594225 = validateParameter(valid_594225, JInt, required = false, default = nil)
  if valid_594225 != nil:
    section.add "pageSize", valid_594225
  var valid_594226 = query.getOrDefault("prettyPrint")
  valid_594226 = validateParameter(valid_594226, JBool, required = false,
                                 default = newJBool(true))
  if valid_594226 != nil:
    section.add "prettyPrint", valid_594226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594227: Call_FirebaseProjectsWebAppsList_594210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_FirebaseProjectsWebAppsList_594210; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## firebaseProjectsWebAppsList
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListWebApps` indicating where in
  ## the set of Apps to resume listing.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594229 = newJObject()
  var query_594230 = newJObject()
  add(query_594230, "upload_protocol", newJString(uploadProtocol))
  add(query_594230, "fields", newJString(fields))
  add(query_594230, "pageToken", newJString(pageToken))
  add(query_594230, "quotaUser", newJString(quotaUser))
  add(query_594230, "alt", newJString(alt))
  add(query_594230, "oauth_token", newJString(oauthToken))
  add(query_594230, "callback", newJString(callback))
  add(query_594230, "access_token", newJString(accessToken))
  add(query_594230, "uploadType", newJString(uploadType))
  add(path_594229, "parent", newJString(parent))
  add(query_594230, "key", newJString(key))
  add(query_594230, "$.xgafv", newJString(Xgafv))
  add(query_594230, "pageSize", newJInt(pageSize))
  add(query_594230, "prettyPrint", newJBool(prettyPrint))
  result = call_594228.call(path_594229, query_594230, nil, nil, nil)

var firebaseProjectsWebAppsList* = Call_FirebaseProjectsWebAppsList_594210(
    name: "firebaseProjectsWebAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/webApps",
    validator: validate_FirebaseProjectsWebAppsList_594211, base: "/",
    url: url_FirebaseProjectsWebAppsList_594212, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAddGoogleAnalytics_594252 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsAddGoogleAnalytics_594254(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":addGoogleAnalytics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAddGoogleAnalytics_594253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Provision a new Google Analytics property and associate the new
  ## property with your `FirebaseProject`.</li>
  ## <li>Associate an existing Google Analytics property with your
  ## `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ul>
  ## <li>Any Firebase Apps already in your `FirebaseProject` are
  ## automatically provisioned as new <em>data streams</em> in the Google
  ## Analytics property.</li>
  ## <li>Any <em>data streams</em> already in the Google Analytics property are
  ## automatically associated with their corresponding Firebase Apps (only
  ## applies when an app's `packageName` or `bundleId` match those for an
  ## existing data stream).</li>
  ## </ul>
  ## Learn more about the hierarchy and structure of Google Analytics
  ## accounts in the
  ## [Analytics
  ## documentation](https://support.google.com/analytics/answer/9303323).
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## an AnalyticsDetails; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status.
  ## <br>
  ## <br>To call `AddGoogleAnalytics`, a member must be an Owner for
  ## the existing `FirebaseProject` and have the
  ## [`Edit` permission](https://support.google.com/analytics/answer/2884495)
  ## for the Google Analytics account.
  ## <br>
  ## <br>If a `FirebaseProject` already has Google Analytics enabled, and you
  ## call `AddGoogleAnalytics` using an `analyticsPropertyId` that's different
  ## from the currently associated property, then the call will fail. Analytics
  ## may have already been enabled in the Firebase console or by specifying
  ## `timeZone` and `regionCode` in the call to
  ## [`AddFirebase`](../../v1beta1/projects/addFirebase).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent `FirebaseProject` to link to an existing Google Analytics
  ## account, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594255 = path.getOrDefault("parent")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "parent", valid_594255
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
  var valid_594256 = query.getOrDefault("upload_protocol")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "upload_protocol", valid_594256
  var valid_594257 = query.getOrDefault("fields")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "fields", valid_594257
  var valid_594258 = query.getOrDefault("quotaUser")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "quotaUser", valid_594258
  var valid_594259 = query.getOrDefault("alt")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = newJString("json"))
  if valid_594259 != nil:
    section.add "alt", valid_594259
  var valid_594260 = query.getOrDefault("oauth_token")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "oauth_token", valid_594260
  var valid_594261 = query.getOrDefault("callback")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "callback", valid_594261
  var valid_594262 = query.getOrDefault("access_token")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "access_token", valid_594262
  var valid_594263 = query.getOrDefault("uploadType")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "uploadType", valid_594263
  var valid_594264 = query.getOrDefault("key")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "key", valid_594264
  var valid_594265 = query.getOrDefault("$.xgafv")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = newJString("1"))
  if valid_594265 != nil:
    section.add "$.xgafv", valid_594265
  var valid_594266 = query.getOrDefault("prettyPrint")
  valid_594266 = validateParameter(valid_594266, JBool, required = false,
                                 default = newJBool(true))
  if valid_594266 != nil:
    section.add "prettyPrint", valid_594266
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

proc call*(call_594268: Call_FirebaseProjectsAddGoogleAnalytics_594252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Provision a new Google Analytics property and associate the new
  ## property with your `FirebaseProject`.</li>
  ## <li>Associate an existing Google Analytics property with your
  ## `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ul>
  ## <li>Any Firebase Apps already in your `FirebaseProject` are
  ## automatically provisioned as new <em>data streams</em> in the Google
  ## Analytics property.</li>
  ## <li>Any <em>data streams</em> already in the Google Analytics property are
  ## automatically associated with their corresponding Firebase Apps (only
  ## applies when an app's `packageName` or `bundleId` match those for an
  ## existing data stream).</li>
  ## </ul>
  ## Learn more about the hierarchy and structure of Google Analytics
  ## accounts in the
  ## [Analytics
  ## documentation](https://support.google.com/analytics/answer/9303323).
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## an AnalyticsDetails; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status.
  ## <br>
  ## <br>To call `AddGoogleAnalytics`, a member must be an Owner for
  ## the existing `FirebaseProject` and have the
  ## [`Edit` permission](https://support.google.com/analytics/answer/2884495)
  ## for the Google Analytics account.
  ## <br>
  ## <br>If a `FirebaseProject` already has Google Analytics enabled, and you
  ## call `AddGoogleAnalytics` using an `analyticsPropertyId` that's different
  ## from the currently associated property, then the call will fail. Analytics
  ## may have already been enabled in the Firebase console or by specifying
  ## `timeZone` and `regionCode` in the call to
  ## [`AddFirebase`](../../v1beta1/projects/addFirebase).
  ## 
  let valid = call_594268.validator(path, query, header, formData, body)
  let scheme = call_594268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594268.url(scheme.get, call_594268.host, call_594268.base,
                         call_594268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594268, url, valid)

proc call*(call_594269: Call_FirebaseProjectsAddGoogleAnalytics_594252;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebaseProjectsAddGoogleAnalytics
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Provision a new Google Analytics property and associate the new
  ## property with your `FirebaseProject`.</li>
  ## <li>Associate an existing Google Analytics property with your
  ## `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ul>
  ## <li>Any Firebase Apps already in your `FirebaseProject` are
  ## automatically provisioned as new <em>data streams</em> in the Google
  ## Analytics property.</li>
  ## <li>Any <em>data streams</em> already in the Google Analytics property are
  ## automatically associated with their corresponding Firebase Apps (only
  ## applies when an app's `packageName` or `bundleId` match those for an
  ## existing data stream).</li>
  ## </ul>
  ## Learn more about the hierarchy and structure of Google Analytics
  ## accounts in the
  ## [Analytics
  ## documentation](https://support.google.com/analytics/answer/9303323).
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## an AnalyticsDetails; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status.
  ## <br>
  ## <br>To call `AddGoogleAnalytics`, a member must be an Owner for
  ## the existing `FirebaseProject` and have the
  ## [`Edit` permission](https://support.google.com/analytics/answer/2884495)
  ## for the Google Analytics account.
  ## <br>
  ## <br>If a `FirebaseProject` already has Google Analytics enabled, and you
  ## call `AddGoogleAnalytics` using an `analyticsPropertyId` that's different
  ## from the currently associated property, then the call will fail. Analytics
  ## may have already been enabled in the Firebase console or by specifying
  ## `timeZone` and `regionCode` in the call to
  ## [`AddFirebase`](../../v1beta1/projects/addFirebase).
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
  ##         : The parent `FirebaseProject` to link to an existing Google Analytics
  ## account, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594270 = newJObject()
  var query_594271 = newJObject()
  var body_594272 = newJObject()
  add(query_594271, "upload_protocol", newJString(uploadProtocol))
  add(query_594271, "fields", newJString(fields))
  add(query_594271, "quotaUser", newJString(quotaUser))
  add(query_594271, "alt", newJString(alt))
  add(query_594271, "oauth_token", newJString(oauthToken))
  add(query_594271, "callback", newJString(callback))
  add(query_594271, "access_token", newJString(accessToken))
  add(query_594271, "uploadType", newJString(uploadType))
  add(path_594270, "parent", newJString(parent))
  add(query_594271, "key", newJString(key))
  add(query_594271, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594272 = body
  add(query_594271, "prettyPrint", newJBool(prettyPrint))
  result = call_594269.call(path_594270, query_594271, nil, nil, body_594272)

var firebaseProjectsAddGoogleAnalytics* = Call_FirebaseProjectsAddGoogleAnalytics_594252(
    name: "firebaseProjectsAddGoogleAnalytics", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}:addGoogleAnalytics",
    validator: validate_FirebaseProjectsAddGoogleAnalytics_594253, base: "/",
    url: url_FirebaseProjectsAddGoogleAnalytics_594254, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsRemoveAnalytics_594273 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsRemoveAnalytics_594275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":removeAnalytics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsRemoveAnalytics_594274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unlinks the specified `FirebaseProject` from its Google Analytics account.
  ## <br>
  ## <br>This call removes the association of the specified `FirebaseProject`
  ## with its current Google Analytics property. However, this call does not
  ## delete the Google Analytics resources, such as the Google Analytics
  ## property or any data streams.
  ## <br>
  ## <br>These resources may be re-associated later to the `FirebaseProject` by
  ## calling
  ## [`AddGoogleAnalytics`](../../v1beta1/projects/addGoogleAnalytics) and
  ## specifying the same `analyticsPropertyId`.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent `FirebaseProject` to unlink from its Google Analytics account,
  ## in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594276 = path.getOrDefault("parent")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "parent", valid_594276
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
  var valid_594277 = query.getOrDefault("upload_protocol")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "upload_protocol", valid_594277
  var valid_594278 = query.getOrDefault("fields")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "fields", valid_594278
  var valid_594279 = query.getOrDefault("quotaUser")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "quotaUser", valid_594279
  var valid_594280 = query.getOrDefault("alt")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = newJString("json"))
  if valid_594280 != nil:
    section.add "alt", valid_594280
  var valid_594281 = query.getOrDefault("oauth_token")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "oauth_token", valid_594281
  var valid_594282 = query.getOrDefault("callback")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "callback", valid_594282
  var valid_594283 = query.getOrDefault("access_token")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "access_token", valid_594283
  var valid_594284 = query.getOrDefault("uploadType")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "uploadType", valid_594284
  var valid_594285 = query.getOrDefault("key")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "key", valid_594285
  var valid_594286 = query.getOrDefault("$.xgafv")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = newJString("1"))
  if valid_594286 != nil:
    section.add "$.xgafv", valid_594286
  var valid_594287 = query.getOrDefault("prettyPrint")
  valid_594287 = validateParameter(valid_594287, JBool, required = false,
                                 default = newJBool(true))
  if valid_594287 != nil:
    section.add "prettyPrint", valid_594287
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

proc call*(call_594289: Call_FirebaseProjectsRemoveAnalytics_594273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unlinks the specified `FirebaseProject` from its Google Analytics account.
  ## <br>
  ## <br>This call removes the association of the specified `FirebaseProject`
  ## with its current Google Analytics property. However, this call does not
  ## delete the Google Analytics resources, such as the Google Analytics
  ## property or any data streams.
  ## <br>
  ## <br>These resources may be re-associated later to the `FirebaseProject` by
  ## calling
  ## [`AddGoogleAnalytics`](../../v1beta1/projects/addGoogleAnalytics) and
  ## specifying the same `analyticsPropertyId`.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
  ## 
  let valid = call_594289.validator(path, query, header, formData, body)
  let scheme = call_594289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594289.url(scheme.get, call_594289.host, call_594289.base,
                         call_594289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594289, url, valid)

proc call*(call_594290: Call_FirebaseProjectsRemoveAnalytics_594273;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firebaseProjectsRemoveAnalytics
  ## Unlinks the specified `FirebaseProject` from its Google Analytics account.
  ## <br>
  ## <br>This call removes the association of the specified `FirebaseProject`
  ## with its current Google Analytics property. However, this call does not
  ## delete the Google Analytics resources, such as the Google Analytics
  ## property or any data streams.
  ## <br>
  ## <br>These resources may be re-associated later to the `FirebaseProject` by
  ## calling
  ## [`AddGoogleAnalytics`](../../v1beta1/projects/addGoogleAnalytics) and
  ## specifying the same `analyticsPropertyId`.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
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
  ##         : The parent `FirebaseProject` to unlink from its Google Analytics account,
  ## in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594291 = newJObject()
  var query_594292 = newJObject()
  var body_594293 = newJObject()
  add(query_594292, "upload_protocol", newJString(uploadProtocol))
  add(query_594292, "fields", newJString(fields))
  add(query_594292, "quotaUser", newJString(quotaUser))
  add(query_594292, "alt", newJString(alt))
  add(query_594292, "oauth_token", newJString(oauthToken))
  add(query_594292, "callback", newJString(callback))
  add(query_594292, "access_token", newJString(accessToken))
  add(query_594292, "uploadType", newJString(uploadType))
  add(path_594291, "parent", newJString(parent))
  add(query_594292, "key", newJString(key))
  add(query_594292, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594293 = body
  add(query_594292, "prettyPrint", newJBool(prettyPrint))
  result = call_594290.call(path_594291, query_594292, nil, nil, body_594293)

var firebaseProjectsRemoveAnalytics* = Call_FirebaseProjectsRemoveAnalytics_594273(
    name: "firebaseProjectsRemoveAnalytics", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}:removeAnalytics",
    validator: validate_FirebaseProjectsRemoveAnalytics_594274, base: "/",
    url: url_FirebaseProjectsRemoveAnalytics_594275, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsSearchApps_594294 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsSearchApps_594296(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":searchApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsSearchApps_594295(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594297 = path.getOrDefault("parent")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "parent", valid_594297
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `SearchFirebaseApps` indicating
  ## where in the set of Apps to resume listing.
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594298 = query.getOrDefault("upload_protocol")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "upload_protocol", valid_594298
  var valid_594299 = query.getOrDefault("fields")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "fields", valid_594299
  var valid_594300 = query.getOrDefault("pageToken")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "pageToken", valid_594300
  var valid_594301 = query.getOrDefault("quotaUser")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "quotaUser", valid_594301
  var valid_594302 = query.getOrDefault("alt")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = newJString("json"))
  if valid_594302 != nil:
    section.add "alt", valid_594302
  var valid_594303 = query.getOrDefault("oauth_token")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "oauth_token", valid_594303
  var valid_594304 = query.getOrDefault("callback")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "callback", valid_594304
  var valid_594305 = query.getOrDefault("access_token")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "access_token", valid_594305
  var valid_594306 = query.getOrDefault("uploadType")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "uploadType", valid_594306
  var valid_594307 = query.getOrDefault("key")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "key", valid_594307
  var valid_594308 = query.getOrDefault("$.xgafv")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = newJString("1"))
  if valid_594308 != nil:
    section.add "$.xgafv", valid_594308
  var valid_594309 = query.getOrDefault("pageSize")
  valid_594309 = validateParameter(valid_594309, JInt, required = false, default = nil)
  if valid_594309 != nil:
    section.add "pageSize", valid_594309
  var valid_594310 = query.getOrDefault("prettyPrint")
  valid_594310 = validateParameter(valid_594310, JBool, required = false,
                                 default = newJBool(true))
  if valid_594310 != nil:
    section.add "prettyPrint", valid_594310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594311: Call_FirebaseProjectsSearchApps_594294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ## 
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_FirebaseProjectsSearchApps_594294; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## firebaseProjectsSearchApps
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token returned from a previous call to `SearchFirebaseApps` indicating
  ## where in the set of Apps to resume listing.
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
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  add(query_594314, "upload_protocol", newJString(uploadProtocol))
  add(query_594314, "fields", newJString(fields))
  add(query_594314, "pageToken", newJString(pageToken))
  add(query_594314, "quotaUser", newJString(quotaUser))
  add(query_594314, "alt", newJString(alt))
  add(query_594314, "oauth_token", newJString(oauthToken))
  add(query_594314, "callback", newJString(callback))
  add(query_594314, "access_token", newJString(accessToken))
  add(query_594314, "uploadType", newJString(uploadType))
  add(path_594313, "parent", newJString(parent))
  add(query_594314, "key", newJString(key))
  add(query_594314, "$.xgafv", newJString(Xgafv))
  add(query_594314, "pageSize", newJInt(pageSize))
  add(query_594314, "prettyPrint", newJBool(prettyPrint))
  result = call_594312.call(path_594313, query_594314, nil, nil, nil)

var firebaseProjectsSearchApps* = Call_FirebaseProjectsSearchApps_594294(
    name: "firebaseProjectsSearchApps", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}:searchApps",
    validator: validate_FirebaseProjectsSearchApps_594295, base: "/",
    url: url_FirebaseProjectsSearchApps_594296, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAddFirebase_594315 = ref object of OpenApiRestCall_593408
proc url_FirebaseProjectsAddFirebase_594317(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: ":addFirebase")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseProjectsAddFirebase_594316(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds Firebase resources to the specified existing
  ## [Google Cloud Platform (GCP) `Project`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects).
  ## <br>
  ## <br>Since a FirebaseProject is actually also a GCP `Project`, a
  ## `FirebaseProject` uses underlying GCP identifiers (most importantly,
  ## the `projectId`) as its own for easy interop with GCP APIs.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## a FirebaseProject; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status. The `Operation` is automatically deleted after
  ## completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>This method does not modify any billing account information on the
  ## underlying GCP `Project`.
  ## <br>
  ## <br>To call `AddFirebase`, a member must be an Editor or Owner for the
  ## existing GCP `Project`. Service accounts cannot call `AddFirebase`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The resource name of the GCP `Project` to which Firebase resources will be
  ## added, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## After calling `AddFirebase`, the
  ## 
  ## [`projectId`](https://cloud.google.com/resource-manager/reference/rest/v1/projects#Project.FIELDS.project_id)
  ## of the GCP `Project` is also the `projectId` of the FirebaseProject.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_594318 = path.getOrDefault("project")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "project", valid_594318
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
  var valid_594319 = query.getOrDefault("upload_protocol")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "upload_protocol", valid_594319
  var valid_594320 = query.getOrDefault("fields")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "fields", valid_594320
  var valid_594321 = query.getOrDefault("quotaUser")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "quotaUser", valid_594321
  var valid_594322 = query.getOrDefault("alt")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = newJString("json"))
  if valid_594322 != nil:
    section.add "alt", valid_594322
  var valid_594323 = query.getOrDefault("oauth_token")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "oauth_token", valid_594323
  var valid_594324 = query.getOrDefault("callback")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "callback", valid_594324
  var valid_594325 = query.getOrDefault("access_token")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "access_token", valid_594325
  var valid_594326 = query.getOrDefault("uploadType")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "uploadType", valid_594326
  var valid_594327 = query.getOrDefault("key")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "key", valid_594327
  var valid_594328 = query.getOrDefault("$.xgafv")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = newJString("1"))
  if valid_594328 != nil:
    section.add "$.xgafv", valid_594328
  var valid_594329 = query.getOrDefault("prettyPrint")
  valid_594329 = validateParameter(valid_594329, JBool, required = false,
                                 default = newJBool(true))
  if valid_594329 != nil:
    section.add "prettyPrint", valid_594329
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

proc call*(call_594331: Call_FirebaseProjectsAddFirebase_594315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds Firebase resources to the specified existing
  ## [Google Cloud Platform (GCP) `Project`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects).
  ## <br>
  ## <br>Since a FirebaseProject is actually also a GCP `Project`, a
  ## `FirebaseProject` uses underlying GCP identifiers (most importantly,
  ## the `projectId`) as its own for easy interop with GCP APIs.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## a FirebaseProject; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status. The `Operation` is automatically deleted after
  ## completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>This method does not modify any billing account information on the
  ## underlying GCP `Project`.
  ## <br>
  ## <br>To call `AddFirebase`, a member must be an Editor or Owner for the
  ## existing GCP `Project`. Service accounts cannot call `AddFirebase`.
  ## 
  let valid = call_594331.validator(path, query, header, formData, body)
  let scheme = call_594331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594331.url(scheme.get, call_594331.host, call_594331.base,
                         call_594331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594331, url, valid)

proc call*(call_594332: Call_FirebaseProjectsAddFirebase_594315; project: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## firebaseProjectsAddFirebase
  ## Adds Firebase resources to the specified existing
  ## [Google Cloud Platform (GCP) `Project`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects).
  ## <br>
  ## <br>Since a FirebaseProject is actually also a GCP `Project`, a
  ## `FirebaseProject` uses underlying GCP identifiers (most importantly,
  ## the `projectId`) as its own for easy interop with GCP APIs.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## a FirebaseProject; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status. The `Operation` is automatically deleted after
  ## completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>This method does not modify any billing account information on the
  ## underlying GCP `Project`.
  ## <br>
  ## <br>To call `AddFirebase`, a member must be an Editor or Owner for the
  ## existing GCP `Project`. Service accounts cannot call `AddFirebase`.
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
  ##   project: string (required)
  ##          : The resource name of the GCP `Project` to which Firebase resources will be
  ## added, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## After calling `AddFirebase`, the
  ## 
  ## [`projectId`](https://cloud.google.com/resource-manager/reference/rest/v1/projects#Project.FIELDS.project_id)
  ## of the GCP `Project` is also the `projectId` of the FirebaseProject.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594333 = newJObject()
  var query_594334 = newJObject()
  var body_594335 = newJObject()
  add(query_594334, "upload_protocol", newJString(uploadProtocol))
  add(query_594334, "fields", newJString(fields))
  add(query_594334, "quotaUser", newJString(quotaUser))
  add(query_594334, "alt", newJString(alt))
  add(query_594334, "oauth_token", newJString(oauthToken))
  add(query_594334, "callback", newJString(callback))
  add(query_594334, "access_token", newJString(accessToken))
  add(query_594334, "uploadType", newJString(uploadType))
  add(query_594334, "key", newJString(key))
  add(query_594334, "$.xgafv", newJString(Xgafv))
  add(path_594333, "project", newJString(project))
  if body != nil:
    body_594335 = body
  add(query_594334, "prettyPrint", newJBool(prettyPrint))
  result = call_594332.call(path_594333, query_594334, nil, nil, body_594335)

var firebaseProjectsAddFirebase* = Call_FirebaseProjectsAddFirebase_594315(
    name: "firebaseProjectsAddFirebase", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{project}:addFirebase",
    validator: validate_FirebaseProjectsAddFirebase_594316, base: "/",
    url: url_FirebaseProjectsAddFirebase_594317, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
