
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "firebase"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebaseAvailableProjectsList_588710 = ref object of OpenApiRestCall_588441
proc url_FirebaseAvailableProjectsList_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FirebaseAvailableProjectsList_588711(path: JsonNode; query: JsonNode;
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
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("oauth_token")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "oauth_token", valid_588842
  var valid_588843 = query.getOrDefault("callback")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "callback", valid_588843
  var valid_588844 = query.getOrDefault("access_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "access_token", valid_588844
  var valid_588845 = query.getOrDefault("uploadType")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "uploadType", valid_588845
  var valid_588846 = query.getOrDefault("key")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "key", valid_588846
  var valid_588847 = query.getOrDefault("$.xgafv")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = newJString("1"))
  if valid_588847 != nil:
    section.add "$.xgafv", valid_588847
  var valid_588848 = query.getOrDefault("pageSize")
  valid_588848 = validateParameter(valid_588848, JInt, required = false, default = nil)
  if valid_588848 != nil:
    section.add "pageSize", valid_588848
  var valid_588849 = query.getOrDefault("prettyPrint")
  valid_588849 = validateParameter(valid_588849, JBool, required = false,
                                 default = newJBool(true))
  if valid_588849 != nil:
    section.add "prettyPrint", valid_588849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588872: Call_FirebaseAvailableProjectsList_588710; path: JsonNode;
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
  let valid = call_588872.validator(path, query, header, formData, body)
  let scheme = call_588872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588872.url(scheme.get, call_588872.host, call_588872.base,
                         call_588872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588872, url, valid)

proc call*(call_588943: Call_FirebaseAvailableProjectsList_588710;
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
  var query_588944 = newJObject()
  add(query_588944, "upload_protocol", newJString(uploadProtocol))
  add(query_588944, "fields", newJString(fields))
  add(query_588944, "pageToken", newJString(pageToken))
  add(query_588944, "quotaUser", newJString(quotaUser))
  add(query_588944, "alt", newJString(alt))
  add(query_588944, "oauth_token", newJString(oauthToken))
  add(query_588944, "callback", newJString(callback))
  add(query_588944, "access_token", newJString(accessToken))
  add(query_588944, "uploadType", newJString(uploadType))
  add(query_588944, "key", newJString(key))
  add(query_588944, "$.xgafv", newJString(Xgafv))
  add(query_588944, "pageSize", newJInt(pageSize))
  add(query_588944, "prettyPrint", newJBool(prettyPrint))
  result = call_588943.call(nil, query_588944, nil, nil, nil)

var firebaseAvailableProjectsList* = Call_FirebaseAvailableProjectsList_588710(
    name: "firebaseAvailableProjectsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/availableProjects",
    validator: validate_FirebaseAvailableProjectsList_588711, base: "/",
    url: url_FirebaseAvailableProjectsList_588712, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsList_588984 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsList_588986(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FirebaseProjectsList_588985(path: JsonNode; query: JsonNode;
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
  var valid_588987 = query.getOrDefault("upload_protocol")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "upload_protocol", valid_588987
  var valid_588988 = query.getOrDefault("fields")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "fields", valid_588988
  var valid_588989 = query.getOrDefault("pageToken")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "pageToken", valid_588989
  var valid_588990 = query.getOrDefault("quotaUser")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "quotaUser", valid_588990
  var valid_588991 = query.getOrDefault("alt")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = newJString("json"))
  if valid_588991 != nil:
    section.add "alt", valid_588991
  var valid_588992 = query.getOrDefault("oauth_token")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "oauth_token", valid_588992
  var valid_588993 = query.getOrDefault("callback")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "callback", valid_588993
  var valid_588994 = query.getOrDefault("access_token")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "access_token", valid_588994
  var valid_588995 = query.getOrDefault("uploadType")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "uploadType", valid_588995
  var valid_588996 = query.getOrDefault("key")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "key", valid_588996
  var valid_588997 = query.getOrDefault("$.xgafv")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = newJString("1"))
  if valid_588997 != nil:
    section.add "$.xgafv", valid_588997
  var valid_588998 = query.getOrDefault("pageSize")
  valid_588998 = validateParameter(valid_588998, JInt, required = false, default = nil)
  if valid_588998 != nil:
    section.add "pageSize", valid_588998
  var valid_588999 = query.getOrDefault("prettyPrint")
  valid_588999 = validateParameter(valid_588999, JBool, required = false,
                                 default = newJBool(true))
  if valid_588999 != nil:
    section.add "prettyPrint", valid_588999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589000: Call_FirebaseProjectsList_588984; path: JsonNode;
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
  let valid = call_589000.validator(path, query, header, formData, body)
  let scheme = call_589000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589000.url(scheme.get, call_589000.host, call_589000.base,
                         call_589000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589000, url, valid)

proc call*(call_589001: Call_FirebaseProjectsList_588984;
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
  var query_589002 = newJObject()
  add(query_589002, "upload_protocol", newJString(uploadProtocol))
  add(query_589002, "fields", newJString(fields))
  add(query_589002, "pageToken", newJString(pageToken))
  add(query_589002, "quotaUser", newJString(quotaUser))
  add(query_589002, "alt", newJString(alt))
  add(query_589002, "oauth_token", newJString(oauthToken))
  add(query_589002, "callback", newJString(callback))
  add(query_589002, "access_token", newJString(accessToken))
  add(query_589002, "uploadType", newJString(uploadType))
  add(query_589002, "key", newJString(key))
  add(query_589002, "$.xgafv", newJString(Xgafv))
  add(query_589002, "pageSize", newJInt(pageSize))
  add(query_589002, "prettyPrint", newJBool(prettyPrint))
  result = call_589001.call(nil, query_589002, nil, nil, nil)

var firebaseProjectsList* = Call_FirebaseProjectsList_588984(
    name: "firebaseProjectsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/projects",
    validator: validate_FirebaseProjectsList_588985, base: "/",
    url: url_FirebaseProjectsList_588986, schemes: {Scheme.Https})
type
  Call_FirebaseOperationsGet_589003 = ref object of OpenApiRestCall_588441
proc url_FirebaseOperationsGet_589005(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebaseOperationsGet_589004(path: JsonNode; query: JsonNode;
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589032: Call_FirebaseOperationsGet_589003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_589032.validator(path, query, header, formData, body)
  let scheme = call_589032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589032.url(scheme.get, call_589032.host, call_589032.base,
                         call_589032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589032, url, valid)

proc call*(call_589033: Call_FirebaseOperationsGet_589003; name: string;
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
  var path_589034 = newJObject()
  var query_589035 = newJObject()
  add(query_589035, "upload_protocol", newJString(uploadProtocol))
  add(query_589035, "fields", newJString(fields))
  add(query_589035, "quotaUser", newJString(quotaUser))
  add(path_589034, "name", newJString(name))
  add(query_589035, "alt", newJString(alt))
  add(query_589035, "oauth_token", newJString(oauthToken))
  add(query_589035, "callback", newJString(callback))
  add(query_589035, "access_token", newJString(accessToken))
  add(query_589035, "uploadType", newJString(uploadType))
  add(query_589035, "key", newJString(key))
  add(query_589035, "$.xgafv", newJString(Xgafv))
  add(query_589035, "prettyPrint", newJBool(prettyPrint))
  result = call_589033.call(path_589034, query_589035, nil, nil, nil)

var firebaseOperationsGet* = Call_FirebaseOperationsGet_589003(
    name: "firebaseOperationsGet", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseOperationsGet_589004, base: "/",
    url: url_FirebaseOperationsGet_589005, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsPatch_589055 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsIosAppsPatch_589057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebaseProjectsIosAppsPatch_589056(path: JsonNode; query: JsonNode;
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
  var valid_589058 = path.getOrDefault("name")
  valid_589058 = validateParameter(valid_589058, JString, required = true,
                                 default = nil)
  if valid_589058 != nil:
    section.add "name", valid_589058
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
  var valid_589059 = query.getOrDefault("upload_protocol")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "upload_protocol", valid_589059
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("quotaUser")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "quotaUser", valid_589061
  var valid_589062 = query.getOrDefault("alt")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("json"))
  if valid_589062 != nil:
    section.add "alt", valid_589062
  var valid_589063 = query.getOrDefault("oauth_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "oauth_token", valid_589063
  var valid_589064 = query.getOrDefault("callback")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "callback", valid_589064
  var valid_589065 = query.getOrDefault("access_token")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "access_token", valid_589065
  var valid_589066 = query.getOrDefault("uploadType")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "uploadType", valid_589066
  var valid_589067 = query.getOrDefault("key")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "key", valid_589067
  var valid_589068 = query.getOrDefault("$.xgafv")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("1"))
  if valid_589068 != nil:
    section.add "$.xgafv", valid_589068
  var valid_589069 = query.getOrDefault("prettyPrint")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "prettyPrint", valid_589069
  var valid_589070 = query.getOrDefault("updateMask")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "updateMask", valid_589070
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

proc call*(call_589072: Call_FirebaseProjectsIosAppsPatch_589055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
  ## 
  let valid = call_589072.validator(path, query, header, formData, body)
  let scheme = call_589072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589072.url(scheme.get, call_589072.host, call_589072.base,
                         call_589072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589072, url, valid)

proc call*(call_589073: Call_FirebaseProjectsIosAppsPatch_589055; name: string;
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
  var path_589074 = newJObject()
  var query_589075 = newJObject()
  var body_589076 = newJObject()
  add(query_589075, "upload_protocol", newJString(uploadProtocol))
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(path_589074, "name", newJString(name))
  add(query_589075, "alt", newJString(alt))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(query_589075, "callback", newJString(callback))
  add(query_589075, "access_token", newJString(accessToken))
  add(query_589075, "uploadType", newJString(uploadType))
  add(query_589075, "key", newJString(key))
  add(query_589075, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589076 = body
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  add(query_589075, "updateMask", newJString(updateMask))
  result = call_589073.call(path_589074, query_589075, nil, nil, body_589076)

var firebaseProjectsIosAppsPatch* = Call_FirebaseProjectsIosAppsPatch_589055(
    name: "firebaseProjectsIosAppsPatch", meth: HttpMethod.HttpPatch,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseProjectsIosAppsPatch_589056, base: "/",
    url: url_FirebaseProjectsIosAppsPatch_589057, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaDelete_589036 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsAndroidAppsShaDelete_589038(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebaseProjectsAndroidAppsShaDelete_589037(path: JsonNode;
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
  var valid_589039 = path.getOrDefault("name")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "name", valid_589039
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
  var valid_589040 = query.getOrDefault("upload_protocol")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "upload_protocol", valid_589040
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  var valid_589042 = query.getOrDefault("quotaUser")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "quotaUser", valid_589042
  var valid_589043 = query.getOrDefault("alt")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("json"))
  if valid_589043 != nil:
    section.add "alt", valid_589043
  var valid_589044 = query.getOrDefault("oauth_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "oauth_token", valid_589044
  var valid_589045 = query.getOrDefault("callback")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "callback", valid_589045
  var valid_589046 = query.getOrDefault("access_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "access_token", valid_589046
  var valid_589047 = query.getOrDefault("uploadType")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "uploadType", valid_589047
  var valid_589048 = query.getOrDefault("key")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "key", valid_589048
  var valid_589049 = query.getOrDefault("$.xgafv")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("1"))
  if valid_589049 != nil:
    section.add "$.xgafv", valid_589049
  var valid_589050 = query.getOrDefault("prettyPrint")
  valid_589050 = validateParameter(valid_589050, JBool, required = false,
                                 default = newJBool(true))
  if valid_589050 != nil:
    section.add "prettyPrint", valid_589050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589051: Call_FirebaseProjectsAndroidAppsShaDelete_589036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a SHA certificate from the specified AndroidApp.
  ## 
  let valid = call_589051.validator(path, query, header, formData, body)
  let scheme = call_589051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589051.url(scheme.get, call_589051.host, call_589051.base,
                         call_589051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589051, url, valid)

proc call*(call_589052: Call_FirebaseProjectsAndroidAppsShaDelete_589036;
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
  var path_589053 = newJObject()
  var query_589054 = newJObject()
  add(query_589054, "upload_protocol", newJString(uploadProtocol))
  add(query_589054, "fields", newJString(fields))
  add(query_589054, "quotaUser", newJString(quotaUser))
  add(path_589053, "name", newJString(name))
  add(query_589054, "alt", newJString(alt))
  add(query_589054, "oauth_token", newJString(oauthToken))
  add(query_589054, "callback", newJString(callback))
  add(query_589054, "access_token", newJString(accessToken))
  add(query_589054, "uploadType", newJString(uploadType))
  add(query_589054, "key", newJString(key))
  add(query_589054, "$.xgafv", newJString(Xgafv))
  add(query_589054, "prettyPrint", newJBool(prettyPrint))
  result = call_589052.call(path_589053, query_589054, nil, nil, nil)

var firebaseProjectsAndroidAppsShaDelete* = Call_FirebaseProjectsAndroidAppsShaDelete_589036(
    name: "firebaseProjectsAndroidAppsShaDelete", meth: HttpMethod.HttpDelete,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseProjectsAndroidAppsShaDelete_589037, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaDelete_589038, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsCreate_589098 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsAndroidAppsCreate_589100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsAndroidAppsCreate_589099(path: JsonNode;
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
  var valid_589101 = path.getOrDefault("parent")
  valid_589101 = validateParameter(valid_589101, JString, required = true,
                                 default = nil)
  if valid_589101 != nil:
    section.add "parent", valid_589101
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
  var valid_589102 = query.getOrDefault("upload_protocol")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "upload_protocol", valid_589102
  var valid_589103 = query.getOrDefault("fields")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "fields", valid_589103
  var valid_589104 = query.getOrDefault("quotaUser")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "quotaUser", valid_589104
  var valid_589105 = query.getOrDefault("alt")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("json"))
  if valid_589105 != nil:
    section.add "alt", valid_589105
  var valid_589106 = query.getOrDefault("oauth_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "oauth_token", valid_589106
  var valid_589107 = query.getOrDefault("callback")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "callback", valid_589107
  var valid_589108 = query.getOrDefault("access_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "access_token", valid_589108
  var valid_589109 = query.getOrDefault("uploadType")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "uploadType", valid_589109
  var valid_589110 = query.getOrDefault("key")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "key", valid_589110
  var valid_589111 = query.getOrDefault("$.xgafv")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("1"))
  if valid_589111 != nil:
    section.add "$.xgafv", valid_589111
  var valid_589112 = query.getOrDefault("prettyPrint")
  valid_589112 = validateParameter(valid_589112, JBool, required = false,
                                 default = newJBool(true))
  if valid_589112 != nil:
    section.add "prettyPrint", valid_589112
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

proc call*(call_589114: Call_FirebaseProjectsAndroidAppsCreate_589098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_589114.validator(path, query, header, formData, body)
  let scheme = call_589114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589114.url(scheme.get, call_589114.host, call_589114.base,
                         call_589114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589114, url, valid)

proc call*(call_589115: Call_FirebaseProjectsAndroidAppsCreate_589098;
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
  var path_589116 = newJObject()
  var query_589117 = newJObject()
  var body_589118 = newJObject()
  add(query_589117, "upload_protocol", newJString(uploadProtocol))
  add(query_589117, "fields", newJString(fields))
  add(query_589117, "quotaUser", newJString(quotaUser))
  add(query_589117, "alt", newJString(alt))
  add(query_589117, "oauth_token", newJString(oauthToken))
  add(query_589117, "callback", newJString(callback))
  add(query_589117, "access_token", newJString(accessToken))
  add(query_589117, "uploadType", newJString(uploadType))
  add(path_589116, "parent", newJString(parent))
  add(query_589117, "key", newJString(key))
  add(query_589117, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589118 = body
  add(query_589117, "prettyPrint", newJBool(prettyPrint))
  result = call_589115.call(path_589116, query_589117, nil, nil, body_589118)

var firebaseProjectsAndroidAppsCreate* = Call_FirebaseProjectsAndroidAppsCreate_589098(
    name: "firebaseProjectsAndroidAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/androidApps",
    validator: validate_FirebaseProjectsAndroidAppsCreate_589099, base: "/",
    url: url_FirebaseProjectsAndroidAppsCreate_589100, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsList_589077 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsAndroidAppsList_589079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsAndroidAppsList_589078(path: JsonNode;
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
  var valid_589080 = path.getOrDefault("parent")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "parent", valid_589080
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
  var valid_589081 = query.getOrDefault("upload_protocol")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "upload_protocol", valid_589081
  var valid_589082 = query.getOrDefault("fields")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "fields", valid_589082
  var valid_589083 = query.getOrDefault("pageToken")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "pageToken", valid_589083
  var valid_589084 = query.getOrDefault("quotaUser")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "quotaUser", valid_589084
  var valid_589085 = query.getOrDefault("alt")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("json"))
  if valid_589085 != nil:
    section.add "alt", valid_589085
  var valid_589086 = query.getOrDefault("oauth_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "oauth_token", valid_589086
  var valid_589087 = query.getOrDefault("callback")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "callback", valid_589087
  var valid_589088 = query.getOrDefault("access_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "access_token", valid_589088
  var valid_589089 = query.getOrDefault("uploadType")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "uploadType", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("$.xgafv")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("1"))
  if valid_589091 != nil:
    section.add "$.xgafv", valid_589091
  var valid_589092 = query.getOrDefault("pageSize")
  valid_589092 = validateParameter(valid_589092, JInt, required = false, default = nil)
  if valid_589092 != nil:
    section.add "pageSize", valid_589092
  var valid_589093 = query.getOrDefault("prettyPrint")
  valid_589093 = validateParameter(valid_589093, JBool, required = false,
                                 default = newJBool(true))
  if valid_589093 != nil:
    section.add "prettyPrint", valid_589093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589094: Call_FirebaseProjectsAndroidAppsList_589077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_589094.validator(path, query, header, formData, body)
  let scheme = call_589094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589094.url(scheme.get, call_589094.host, call_589094.base,
                         call_589094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589094, url, valid)

proc call*(call_589095: Call_FirebaseProjectsAndroidAppsList_589077;
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
  var path_589096 = newJObject()
  var query_589097 = newJObject()
  add(query_589097, "upload_protocol", newJString(uploadProtocol))
  add(query_589097, "fields", newJString(fields))
  add(query_589097, "pageToken", newJString(pageToken))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(query_589097, "alt", newJString(alt))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(query_589097, "callback", newJString(callback))
  add(query_589097, "access_token", newJString(accessToken))
  add(query_589097, "uploadType", newJString(uploadType))
  add(path_589096, "parent", newJString(parent))
  add(query_589097, "key", newJString(key))
  add(query_589097, "$.xgafv", newJString(Xgafv))
  add(query_589097, "pageSize", newJInt(pageSize))
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  result = call_589095.call(path_589096, query_589097, nil, nil, nil)

var firebaseProjectsAndroidAppsList* = Call_FirebaseProjectsAndroidAppsList_589077(
    name: "firebaseProjectsAndroidAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/androidApps",
    validator: validate_FirebaseProjectsAndroidAppsList_589078, base: "/",
    url: url_FirebaseProjectsAndroidAppsList_589079, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAvailableLocationsList_589119 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsAvailableLocationsList_589121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsAvailableLocationsList_589120(path: JsonNode;
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
  var valid_589122 = path.getOrDefault("parent")
  valid_589122 = validateParameter(valid_589122, JString, required = true,
                                 default = nil)
  if valid_589122 != nil:
    section.add "parent", valid_589122
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
  var valid_589123 = query.getOrDefault("upload_protocol")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "upload_protocol", valid_589123
  var valid_589124 = query.getOrDefault("fields")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "fields", valid_589124
  var valid_589125 = query.getOrDefault("pageToken")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "pageToken", valid_589125
  var valid_589126 = query.getOrDefault("quotaUser")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "quotaUser", valid_589126
  var valid_589127 = query.getOrDefault("alt")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("json"))
  if valid_589127 != nil:
    section.add "alt", valid_589127
  var valid_589128 = query.getOrDefault("oauth_token")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "oauth_token", valid_589128
  var valid_589129 = query.getOrDefault("callback")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "callback", valid_589129
  var valid_589130 = query.getOrDefault("access_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "access_token", valid_589130
  var valid_589131 = query.getOrDefault("uploadType")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "uploadType", valid_589131
  var valid_589132 = query.getOrDefault("key")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "key", valid_589132
  var valid_589133 = query.getOrDefault("$.xgafv")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = newJString("1"))
  if valid_589133 != nil:
    section.add "$.xgafv", valid_589133
  var valid_589134 = query.getOrDefault("pageSize")
  valid_589134 = validateParameter(valid_589134, JInt, required = false, default = nil)
  if valid_589134 != nil:
    section.add "pageSize", valid_589134
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
  if body != nil:
    result.add "body", body

proc call*(call_589136: Call_FirebaseProjectsAvailableLocationsList_589119;
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
  let valid = call_589136.validator(path, query, header, formData, body)
  let scheme = call_589136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589136.url(scheme.get, call_589136.host, call_589136.base,
                         call_589136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589136, url, valid)

proc call*(call_589137: Call_FirebaseProjectsAvailableLocationsList_589119;
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
  var path_589138 = newJObject()
  var query_589139 = newJObject()
  add(query_589139, "upload_protocol", newJString(uploadProtocol))
  add(query_589139, "fields", newJString(fields))
  add(query_589139, "pageToken", newJString(pageToken))
  add(query_589139, "quotaUser", newJString(quotaUser))
  add(query_589139, "alt", newJString(alt))
  add(query_589139, "oauth_token", newJString(oauthToken))
  add(query_589139, "callback", newJString(callback))
  add(query_589139, "access_token", newJString(accessToken))
  add(query_589139, "uploadType", newJString(uploadType))
  add(path_589138, "parent", newJString(parent))
  add(query_589139, "key", newJString(key))
  add(query_589139, "$.xgafv", newJString(Xgafv))
  add(query_589139, "pageSize", newJInt(pageSize))
  add(query_589139, "prettyPrint", newJBool(prettyPrint))
  result = call_589137.call(path_589138, query_589139, nil, nil, nil)

var firebaseProjectsAvailableLocationsList* = Call_FirebaseProjectsAvailableLocationsList_589119(
    name: "firebaseProjectsAvailableLocationsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}/availableLocations",
    validator: validate_FirebaseProjectsAvailableLocationsList_589120, base: "/",
    url: url_FirebaseProjectsAvailableLocationsList_589121,
    schemes: {Scheme.Https})
type
  Call_FirebaseProjectsDefaultLocationFinalize_589140 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsDefaultLocationFinalize_589142(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsDefaultLocationFinalize_589141(path: JsonNode;
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
  var valid_589143 = path.getOrDefault("parent")
  valid_589143 = validateParameter(valid_589143, JString, required = true,
                                 default = nil)
  if valid_589143 != nil:
    section.add "parent", valid_589143
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
  var valid_589144 = query.getOrDefault("upload_protocol")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "upload_protocol", valid_589144
  var valid_589145 = query.getOrDefault("fields")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "fields", valid_589145
  var valid_589146 = query.getOrDefault("quotaUser")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "quotaUser", valid_589146
  var valid_589147 = query.getOrDefault("alt")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = newJString("json"))
  if valid_589147 != nil:
    section.add "alt", valid_589147
  var valid_589148 = query.getOrDefault("oauth_token")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "oauth_token", valid_589148
  var valid_589149 = query.getOrDefault("callback")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "callback", valid_589149
  var valid_589150 = query.getOrDefault("access_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "access_token", valid_589150
  var valid_589151 = query.getOrDefault("uploadType")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "uploadType", valid_589151
  var valid_589152 = query.getOrDefault("key")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "key", valid_589152
  var valid_589153 = query.getOrDefault("$.xgafv")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("1"))
  if valid_589153 != nil:
    section.add "$.xgafv", valid_589153
  var valid_589154 = query.getOrDefault("prettyPrint")
  valid_589154 = validateParameter(valid_589154, JBool, required = false,
                                 default = newJBool(true))
  if valid_589154 != nil:
    section.add "prettyPrint", valid_589154
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

proc call*(call_589156: Call_FirebaseProjectsDefaultLocationFinalize_589140;
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
  let valid = call_589156.validator(path, query, header, formData, body)
  let scheme = call_589156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589156.url(scheme.get, call_589156.host, call_589156.base,
                         call_589156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589156, url, valid)

proc call*(call_589157: Call_FirebaseProjectsDefaultLocationFinalize_589140;
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
  var path_589158 = newJObject()
  var query_589159 = newJObject()
  var body_589160 = newJObject()
  add(query_589159, "upload_protocol", newJString(uploadProtocol))
  add(query_589159, "fields", newJString(fields))
  add(query_589159, "quotaUser", newJString(quotaUser))
  add(query_589159, "alt", newJString(alt))
  add(query_589159, "oauth_token", newJString(oauthToken))
  add(query_589159, "callback", newJString(callback))
  add(query_589159, "access_token", newJString(accessToken))
  add(query_589159, "uploadType", newJString(uploadType))
  add(path_589158, "parent", newJString(parent))
  add(query_589159, "key", newJString(key))
  add(query_589159, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589160 = body
  add(query_589159, "prettyPrint", newJBool(prettyPrint))
  result = call_589157.call(path_589158, query_589159, nil, nil, body_589160)

var firebaseProjectsDefaultLocationFinalize* = Call_FirebaseProjectsDefaultLocationFinalize_589140(
    name: "firebaseProjectsDefaultLocationFinalize", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}/defaultLocation:finalize",
    validator: validate_FirebaseProjectsDefaultLocationFinalize_589141, base: "/",
    url: url_FirebaseProjectsDefaultLocationFinalize_589142,
    schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsCreate_589182 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsIosAppsCreate_589184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsIosAppsCreate_589183(path: JsonNode; query: JsonNode;
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
  var valid_589185 = path.getOrDefault("parent")
  valid_589185 = validateParameter(valid_589185, JString, required = true,
                                 default = nil)
  if valid_589185 != nil:
    section.add "parent", valid_589185
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
  var valid_589186 = query.getOrDefault("upload_protocol")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "upload_protocol", valid_589186
  var valid_589187 = query.getOrDefault("fields")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "fields", valid_589187
  var valid_589188 = query.getOrDefault("quotaUser")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "quotaUser", valid_589188
  var valid_589189 = query.getOrDefault("alt")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = newJString("json"))
  if valid_589189 != nil:
    section.add "alt", valid_589189
  var valid_589190 = query.getOrDefault("oauth_token")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "oauth_token", valid_589190
  var valid_589191 = query.getOrDefault("callback")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "callback", valid_589191
  var valid_589192 = query.getOrDefault("access_token")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "access_token", valid_589192
  var valid_589193 = query.getOrDefault("uploadType")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "uploadType", valid_589193
  var valid_589194 = query.getOrDefault("key")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "key", valid_589194
  var valid_589195 = query.getOrDefault("$.xgafv")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("1"))
  if valid_589195 != nil:
    section.add "$.xgafv", valid_589195
  var valid_589196 = query.getOrDefault("prettyPrint")
  valid_589196 = validateParameter(valid_589196, JBool, required = false,
                                 default = newJBool(true))
  if valid_589196 != nil:
    section.add "prettyPrint", valid_589196
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

proc call*(call_589198: Call_FirebaseProjectsIosAppsCreate_589182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_589198.validator(path, query, header, formData, body)
  let scheme = call_589198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589198.url(scheme.get, call_589198.host, call_589198.base,
                         call_589198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589198, url, valid)

proc call*(call_589199: Call_FirebaseProjectsIosAppsCreate_589182; parent: string;
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
  var path_589200 = newJObject()
  var query_589201 = newJObject()
  var body_589202 = newJObject()
  add(query_589201, "upload_protocol", newJString(uploadProtocol))
  add(query_589201, "fields", newJString(fields))
  add(query_589201, "quotaUser", newJString(quotaUser))
  add(query_589201, "alt", newJString(alt))
  add(query_589201, "oauth_token", newJString(oauthToken))
  add(query_589201, "callback", newJString(callback))
  add(query_589201, "access_token", newJString(accessToken))
  add(query_589201, "uploadType", newJString(uploadType))
  add(path_589200, "parent", newJString(parent))
  add(query_589201, "key", newJString(key))
  add(query_589201, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589202 = body
  add(query_589201, "prettyPrint", newJBool(prettyPrint))
  result = call_589199.call(path_589200, query_589201, nil, nil, body_589202)

var firebaseProjectsIosAppsCreate* = Call_FirebaseProjectsIosAppsCreate_589182(
    name: "firebaseProjectsIosAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/iosApps",
    validator: validate_FirebaseProjectsIosAppsCreate_589183, base: "/",
    url: url_FirebaseProjectsIosAppsCreate_589184, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsList_589161 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsIosAppsList_589163(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsIosAppsList_589162(path: JsonNode; query: JsonNode;
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
  var valid_589164 = path.getOrDefault("parent")
  valid_589164 = validateParameter(valid_589164, JString, required = true,
                                 default = nil)
  if valid_589164 != nil:
    section.add "parent", valid_589164
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
  var valid_589165 = query.getOrDefault("upload_protocol")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "upload_protocol", valid_589165
  var valid_589166 = query.getOrDefault("fields")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "fields", valid_589166
  var valid_589167 = query.getOrDefault("pageToken")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "pageToken", valid_589167
  var valid_589168 = query.getOrDefault("quotaUser")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "quotaUser", valid_589168
  var valid_589169 = query.getOrDefault("alt")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("json"))
  if valid_589169 != nil:
    section.add "alt", valid_589169
  var valid_589170 = query.getOrDefault("oauth_token")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "oauth_token", valid_589170
  var valid_589171 = query.getOrDefault("callback")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "callback", valid_589171
  var valid_589172 = query.getOrDefault("access_token")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "access_token", valid_589172
  var valid_589173 = query.getOrDefault("uploadType")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "uploadType", valid_589173
  var valid_589174 = query.getOrDefault("key")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "key", valid_589174
  var valid_589175 = query.getOrDefault("$.xgafv")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("1"))
  if valid_589175 != nil:
    section.add "$.xgafv", valid_589175
  var valid_589176 = query.getOrDefault("pageSize")
  valid_589176 = validateParameter(valid_589176, JInt, required = false, default = nil)
  if valid_589176 != nil:
    section.add "pageSize", valid_589176
  var valid_589177 = query.getOrDefault("prettyPrint")
  valid_589177 = validateParameter(valid_589177, JBool, required = false,
                                 default = newJBool(true))
  if valid_589177 != nil:
    section.add "prettyPrint", valid_589177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589178: Call_FirebaseProjectsIosAppsList_589161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_589178.validator(path, query, header, formData, body)
  let scheme = call_589178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589178.url(scheme.get, call_589178.host, call_589178.base,
                         call_589178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589178, url, valid)

proc call*(call_589179: Call_FirebaseProjectsIosAppsList_589161; parent: string;
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
  var path_589180 = newJObject()
  var query_589181 = newJObject()
  add(query_589181, "upload_protocol", newJString(uploadProtocol))
  add(query_589181, "fields", newJString(fields))
  add(query_589181, "pageToken", newJString(pageToken))
  add(query_589181, "quotaUser", newJString(quotaUser))
  add(query_589181, "alt", newJString(alt))
  add(query_589181, "oauth_token", newJString(oauthToken))
  add(query_589181, "callback", newJString(callback))
  add(query_589181, "access_token", newJString(accessToken))
  add(query_589181, "uploadType", newJString(uploadType))
  add(path_589180, "parent", newJString(parent))
  add(query_589181, "key", newJString(key))
  add(query_589181, "$.xgafv", newJString(Xgafv))
  add(query_589181, "pageSize", newJInt(pageSize))
  add(query_589181, "prettyPrint", newJBool(prettyPrint))
  result = call_589179.call(path_589180, query_589181, nil, nil, nil)

var firebaseProjectsIosAppsList* = Call_FirebaseProjectsIosAppsList_589161(
    name: "firebaseProjectsIosAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/iosApps",
    validator: validate_FirebaseProjectsIosAppsList_589162, base: "/",
    url: url_FirebaseProjectsIosAppsList_589163, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaCreate_589222 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsAndroidAppsShaCreate_589224(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsAndroidAppsShaCreate_589223(path: JsonNode;
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
  var valid_589225 = path.getOrDefault("parent")
  valid_589225 = validateParameter(valid_589225, JString, required = true,
                                 default = nil)
  if valid_589225 != nil:
    section.add "parent", valid_589225
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
  var valid_589226 = query.getOrDefault("upload_protocol")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "upload_protocol", valid_589226
  var valid_589227 = query.getOrDefault("fields")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "fields", valid_589227
  var valid_589228 = query.getOrDefault("quotaUser")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "quotaUser", valid_589228
  var valid_589229 = query.getOrDefault("alt")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = newJString("json"))
  if valid_589229 != nil:
    section.add "alt", valid_589229
  var valid_589230 = query.getOrDefault("oauth_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "oauth_token", valid_589230
  var valid_589231 = query.getOrDefault("callback")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "callback", valid_589231
  var valid_589232 = query.getOrDefault("access_token")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "access_token", valid_589232
  var valid_589233 = query.getOrDefault("uploadType")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "uploadType", valid_589233
  var valid_589234 = query.getOrDefault("key")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "key", valid_589234
  var valid_589235 = query.getOrDefault("$.xgafv")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("1"))
  if valid_589235 != nil:
    section.add "$.xgafv", valid_589235
  var valid_589236 = query.getOrDefault("prettyPrint")
  valid_589236 = validateParameter(valid_589236, JBool, required = false,
                                 default = newJBool(true))
  if valid_589236 != nil:
    section.add "prettyPrint", valid_589236
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

proc call*(call_589238: Call_FirebaseProjectsAndroidAppsShaCreate_589222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a SHA certificate to the specified AndroidApp.
  ## 
  let valid = call_589238.validator(path, query, header, formData, body)
  let scheme = call_589238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589238.url(scheme.get, call_589238.host, call_589238.base,
                         call_589238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589238, url, valid)

proc call*(call_589239: Call_FirebaseProjectsAndroidAppsShaCreate_589222;
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
  var path_589240 = newJObject()
  var query_589241 = newJObject()
  var body_589242 = newJObject()
  add(query_589241, "upload_protocol", newJString(uploadProtocol))
  add(query_589241, "fields", newJString(fields))
  add(query_589241, "quotaUser", newJString(quotaUser))
  add(query_589241, "alt", newJString(alt))
  add(query_589241, "oauth_token", newJString(oauthToken))
  add(query_589241, "callback", newJString(callback))
  add(query_589241, "access_token", newJString(accessToken))
  add(query_589241, "uploadType", newJString(uploadType))
  add(path_589240, "parent", newJString(parent))
  add(query_589241, "key", newJString(key))
  add(query_589241, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589242 = body
  add(query_589241, "prettyPrint", newJBool(prettyPrint))
  result = call_589239.call(path_589240, query_589241, nil, nil, body_589242)

var firebaseProjectsAndroidAppsShaCreate* = Call_FirebaseProjectsAndroidAppsShaCreate_589222(
    name: "firebaseProjectsAndroidAppsShaCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/sha",
    validator: validate_FirebaseProjectsAndroidAppsShaCreate_589223, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaCreate_589224, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaList_589203 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsAndroidAppsShaList_589205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsAndroidAppsShaList_589204(path: JsonNode;
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
  var valid_589206 = path.getOrDefault("parent")
  valid_589206 = validateParameter(valid_589206, JString, required = true,
                                 default = nil)
  if valid_589206 != nil:
    section.add "parent", valid_589206
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
  var valid_589207 = query.getOrDefault("upload_protocol")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "upload_protocol", valid_589207
  var valid_589208 = query.getOrDefault("fields")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "fields", valid_589208
  var valid_589209 = query.getOrDefault("quotaUser")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "quotaUser", valid_589209
  var valid_589210 = query.getOrDefault("alt")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = newJString("json"))
  if valid_589210 != nil:
    section.add "alt", valid_589210
  var valid_589211 = query.getOrDefault("oauth_token")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "oauth_token", valid_589211
  var valid_589212 = query.getOrDefault("callback")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "callback", valid_589212
  var valid_589213 = query.getOrDefault("access_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "access_token", valid_589213
  var valid_589214 = query.getOrDefault("uploadType")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "uploadType", valid_589214
  var valid_589215 = query.getOrDefault("key")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "key", valid_589215
  var valid_589216 = query.getOrDefault("$.xgafv")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = newJString("1"))
  if valid_589216 != nil:
    section.add "$.xgafv", valid_589216
  var valid_589217 = query.getOrDefault("prettyPrint")
  valid_589217 = validateParameter(valid_589217, JBool, required = false,
                                 default = newJBool(true))
  if valid_589217 != nil:
    section.add "prettyPrint", valid_589217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589218: Call_FirebaseProjectsAndroidAppsShaList_589203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
  ## 
  let valid = call_589218.validator(path, query, header, formData, body)
  let scheme = call_589218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589218.url(scheme.get, call_589218.host, call_589218.base,
                         call_589218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589218, url, valid)

proc call*(call_589219: Call_FirebaseProjectsAndroidAppsShaList_589203;
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
  var path_589220 = newJObject()
  var query_589221 = newJObject()
  add(query_589221, "upload_protocol", newJString(uploadProtocol))
  add(query_589221, "fields", newJString(fields))
  add(query_589221, "quotaUser", newJString(quotaUser))
  add(query_589221, "alt", newJString(alt))
  add(query_589221, "oauth_token", newJString(oauthToken))
  add(query_589221, "callback", newJString(callback))
  add(query_589221, "access_token", newJString(accessToken))
  add(query_589221, "uploadType", newJString(uploadType))
  add(path_589220, "parent", newJString(parent))
  add(query_589221, "key", newJString(key))
  add(query_589221, "$.xgafv", newJString(Xgafv))
  add(query_589221, "prettyPrint", newJBool(prettyPrint))
  result = call_589219.call(path_589220, query_589221, nil, nil, nil)

var firebaseProjectsAndroidAppsShaList* = Call_FirebaseProjectsAndroidAppsShaList_589203(
    name: "firebaseProjectsAndroidAppsShaList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/sha",
    validator: validate_FirebaseProjectsAndroidAppsShaList_589204, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaList_589205, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsWebAppsCreate_589264 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsWebAppsCreate_589266(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsWebAppsCreate_589265(path: JsonNode; query: JsonNode;
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
  var valid_589267 = path.getOrDefault("parent")
  valid_589267 = validateParameter(valid_589267, JString, required = true,
                                 default = nil)
  if valid_589267 != nil:
    section.add "parent", valid_589267
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
  var valid_589268 = query.getOrDefault("upload_protocol")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "upload_protocol", valid_589268
  var valid_589269 = query.getOrDefault("fields")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "fields", valid_589269
  var valid_589270 = query.getOrDefault("quotaUser")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "quotaUser", valid_589270
  var valid_589271 = query.getOrDefault("alt")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = newJString("json"))
  if valid_589271 != nil:
    section.add "alt", valid_589271
  var valid_589272 = query.getOrDefault("oauth_token")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "oauth_token", valid_589272
  var valid_589273 = query.getOrDefault("callback")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "callback", valid_589273
  var valid_589274 = query.getOrDefault("access_token")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "access_token", valid_589274
  var valid_589275 = query.getOrDefault("uploadType")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "uploadType", valid_589275
  var valid_589276 = query.getOrDefault("key")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "key", valid_589276
  var valid_589277 = query.getOrDefault("$.xgafv")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("1"))
  if valid_589277 != nil:
    section.add "$.xgafv", valid_589277
  var valid_589278 = query.getOrDefault("prettyPrint")
  valid_589278 = validateParameter(valid_589278, JBool, required = false,
                                 default = newJBool(true))
  if valid_589278 != nil:
    section.add "prettyPrint", valid_589278
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

proc call*(call_589280: Call_FirebaseProjectsWebAppsCreate_589264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_589280.validator(path, query, header, formData, body)
  let scheme = call_589280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589280.url(scheme.get, call_589280.host, call_589280.base,
                         call_589280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589280, url, valid)

proc call*(call_589281: Call_FirebaseProjectsWebAppsCreate_589264; parent: string;
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
  var path_589282 = newJObject()
  var query_589283 = newJObject()
  var body_589284 = newJObject()
  add(query_589283, "upload_protocol", newJString(uploadProtocol))
  add(query_589283, "fields", newJString(fields))
  add(query_589283, "quotaUser", newJString(quotaUser))
  add(query_589283, "alt", newJString(alt))
  add(query_589283, "oauth_token", newJString(oauthToken))
  add(query_589283, "callback", newJString(callback))
  add(query_589283, "access_token", newJString(accessToken))
  add(query_589283, "uploadType", newJString(uploadType))
  add(path_589282, "parent", newJString(parent))
  add(query_589283, "key", newJString(key))
  add(query_589283, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589284 = body
  add(query_589283, "prettyPrint", newJBool(prettyPrint))
  result = call_589281.call(path_589282, query_589283, nil, nil, body_589284)

var firebaseProjectsWebAppsCreate* = Call_FirebaseProjectsWebAppsCreate_589264(
    name: "firebaseProjectsWebAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/webApps",
    validator: validate_FirebaseProjectsWebAppsCreate_589265, base: "/",
    url: url_FirebaseProjectsWebAppsCreate_589266, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsWebAppsList_589243 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsWebAppsList_589245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsWebAppsList_589244(path: JsonNode; query: JsonNode;
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
  var valid_589246 = path.getOrDefault("parent")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "parent", valid_589246
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
  var valid_589247 = query.getOrDefault("upload_protocol")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "upload_protocol", valid_589247
  var valid_589248 = query.getOrDefault("fields")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "fields", valid_589248
  var valid_589249 = query.getOrDefault("pageToken")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "pageToken", valid_589249
  var valid_589250 = query.getOrDefault("quotaUser")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "quotaUser", valid_589250
  var valid_589251 = query.getOrDefault("alt")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = newJString("json"))
  if valid_589251 != nil:
    section.add "alt", valid_589251
  var valid_589252 = query.getOrDefault("oauth_token")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "oauth_token", valid_589252
  var valid_589253 = query.getOrDefault("callback")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "callback", valid_589253
  var valid_589254 = query.getOrDefault("access_token")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "access_token", valid_589254
  var valid_589255 = query.getOrDefault("uploadType")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "uploadType", valid_589255
  var valid_589256 = query.getOrDefault("key")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "key", valid_589256
  var valid_589257 = query.getOrDefault("$.xgafv")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("1"))
  if valid_589257 != nil:
    section.add "$.xgafv", valid_589257
  var valid_589258 = query.getOrDefault("pageSize")
  valid_589258 = validateParameter(valid_589258, JInt, required = false, default = nil)
  if valid_589258 != nil:
    section.add "pageSize", valid_589258
  var valid_589259 = query.getOrDefault("prettyPrint")
  valid_589259 = validateParameter(valid_589259, JBool, required = false,
                                 default = newJBool(true))
  if valid_589259 != nil:
    section.add "prettyPrint", valid_589259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589260: Call_FirebaseProjectsWebAppsList_589243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_589260.validator(path, query, header, formData, body)
  let scheme = call_589260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589260.url(scheme.get, call_589260.host, call_589260.base,
                         call_589260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589260, url, valid)

proc call*(call_589261: Call_FirebaseProjectsWebAppsList_589243; parent: string;
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
  var path_589262 = newJObject()
  var query_589263 = newJObject()
  add(query_589263, "upload_protocol", newJString(uploadProtocol))
  add(query_589263, "fields", newJString(fields))
  add(query_589263, "pageToken", newJString(pageToken))
  add(query_589263, "quotaUser", newJString(quotaUser))
  add(query_589263, "alt", newJString(alt))
  add(query_589263, "oauth_token", newJString(oauthToken))
  add(query_589263, "callback", newJString(callback))
  add(query_589263, "access_token", newJString(accessToken))
  add(query_589263, "uploadType", newJString(uploadType))
  add(path_589262, "parent", newJString(parent))
  add(query_589263, "key", newJString(key))
  add(query_589263, "$.xgafv", newJString(Xgafv))
  add(query_589263, "pageSize", newJInt(pageSize))
  add(query_589263, "prettyPrint", newJBool(prettyPrint))
  result = call_589261.call(path_589262, query_589263, nil, nil, nil)

var firebaseProjectsWebAppsList* = Call_FirebaseProjectsWebAppsList_589243(
    name: "firebaseProjectsWebAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/webApps",
    validator: validate_FirebaseProjectsWebAppsList_589244, base: "/",
    url: url_FirebaseProjectsWebAppsList_589245, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAddGoogleAnalytics_589285 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsAddGoogleAnalytics_589287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsAddGoogleAnalytics_589286(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Specify an `analyticsAccountId` to provision a new Google Analytics
  ## property within the specified account and associate the new property with
  ## your `FirebaseProject`.</li>
  ## <li>Specify an existing `analyticsPropertyId` to associate the property
  ## with your `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ol>
  ## <li>The first check determines if any existing data streams in the
  ## Google Analytics property correspond to any existing Firebase Apps in your
  ## `FirebaseProject` (based on the `packageName` or `bundleId` associated with
  ## the data stream). Then, as applicable, the data streams and apps are
  ## linked. Note that this auto-linking only applies to Android Apps and iOS
  ## Apps.</li>
  ## <li>If no corresponding data streams are found for your Firebase Apps,
  ## new data streams are provisioned in the Google Analytics property
  ## for each of your Firebase Apps. Note that a new data stream is always
  ## provisioned for a Web App even if it was previously associated with a
  ## data stream in your Analytics property.</li>
  ## </ol>
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
  var valid_589288 = path.getOrDefault("parent")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "parent", valid_589288
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
  var valid_589289 = query.getOrDefault("upload_protocol")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "upload_protocol", valid_589289
  var valid_589290 = query.getOrDefault("fields")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "fields", valid_589290
  var valid_589291 = query.getOrDefault("quotaUser")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "quotaUser", valid_589291
  var valid_589292 = query.getOrDefault("alt")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = newJString("json"))
  if valid_589292 != nil:
    section.add "alt", valid_589292
  var valid_589293 = query.getOrDefault("oauth_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "oauth_token", valid_589293
  var valid_589294 = query.getOrDefault("callback")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "callback", valid_589294
  var valid_589295 = query.getOrDefault("access_token")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "access_token", valid_589295
  var valid_589296 = query.getOrDefault("uploadType")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "uploadType", valid_589296
  var valid_589297 = query.getOrDefault("key")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "key", valid_589297
  var valid_589298 = query.getOrDefault("$.xgafv")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("1"))
  if valid_589298 != nil:
    section.add "$.xgafv", valid_589298
  var valid_589299 = query.getOrDefault("prettyPrint")
  valid_589299 = validateParameter(valid_589299, JBool, required = false,
                                 default = newJBool(true))
  if valid_589299 != nil:
    section.add "prettyPrint", valid_589299
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

proc call*(call_589301: Call_FirebaseProjectsAddGoogleAnalytics_589285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Specify an `analyticsAccountId` to provision a new Google Analytics
  ## property within the specified account and associate the new property with
  ## your `FirebaseProject`.</li>
  ## <li>Specify an existing `analyticsPropertyId` to associate the property
  ## with your `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ol>
  ## <li>The first check determines if any existing data streams in the
  ## Google Analytics property correspond to any existing Firebase Apps in your
  ## `FirebaseProject` (based on the `packageName` or `bundleId` associated with
  ## the data stream). Then, as applicable, the data streams and apps are
  ## linked. Note that this auto-linking only applies to Android Apps and iOS
  ## Apps.</li>
  ## <li>If no corresponding data streams are found for your Firebase Apps,
  ## new data streams are provisioned in the Google Analytics property
  ## for each of your Firebase Apps. Note that a new data stream is always
  ## provisioned for a Web App even if it was previously associated with a
  ## data stream in your Analytics property.</li>
  ## </ol>
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
  let valid = call_589301.validator(path, query, header, formData, body)
  let scheme = call_589301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589301.url(scheme.get, call_589301.host, call_589301.base,
                         call_589301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589301, url, valid)

proc call*(call_589302: Call_FirebaseProjectsAddGoogleAnalytics_589285;
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
  ## <li>Specify an `analyticsAccountId` to provision a new Google Analytics
  ## property within the specified account and associate the new property with
  ## your `FirebaseProject`.</li>
  ## <li>Specify an existing `analyticsPropertyId` to associate the property
  ## with your `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ol>
  ## <li>The first check determines if any existing data streams in the
  ## Google Analytics property correspond to any existing Firebase Apps in your
  ## `FirebaseProject` (based on the `packageName` or `bundleId` associated with
  ## the data stream). Then, as applicable, the data streams and apps are
  ## linked. Note that this auto-linking only applies to Android Apps and iOS
  ## Apps.</li>
  ## <li>If no corresponding data streams are found for your Firebase Apps,
  ## new data streams are provisioned in the Google Analytics property
  ## for each of your Firebase Apps. Note that a new data stream is always
  ## provisioned for a Web App even if it was previously associated with a
  ## data stream in your Analytics property.</li>
  ## </ol>
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
  var path_589303 = newJObject()
  var query_589304 = newJObject()
  var body_589305 = newJObject()
  add(query_589304, "upload_protocol", newJString(uploadProtocol))
  add(query_589304, "fields", newJString(fields))
  add(query_589304, "quotaUser", newJString(quotaUser))
  add(query_589304, "alt", newJString(alt))
  add(query_589304, "oauth_token", newJString(oauthToken))
  add(query_589304, "callback", newJString(callback))
  add(query_589304, "access_token", newJString(accessToken))
  add(query_589304, "uploadType", newJString(uploadType))
  add(path_589303, "parent", newJString(parent))
  add(query_589304, "key", newJString(key))
  add(query_589304, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589305 = body
  add(query_589304, "prettyPrint", newJBool(prettyPrint))
  result = call_589302.call(path_589303, query_589304, nil, nil, body_589305)

var firebaseProjectsAddGoogleAnalytics* = Call_FirebaseProjectsAddGoogleAnalytics_589285(
    name: "firebaseProjectsAddGoogleAnalytics", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}:addGoogleAnalytics",
    validator: validate_FirebaseProjectsAddGoogleAnalytics_589286, base: "/",
    url: url_FirebaseProjectsAddGoogleAnalytics_589287, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsRemoveAnalytics_589306 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsRemoveAnalytics_589308(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsRemoveAnalytics_589307(path: JsonNode;
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
  ## specifying the same `analyticsPropertyId`. For Android Apps and iOS Apps,
  ## this call re-links data streams with their corresponding apps. However,
  ## for Web Apps, this call provisions a <em>new</em> data stream for each Web
  ## App.
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
  var valid_589309 = path.getOrDefault("parent")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "parent", valid_589309
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
  var valid_589310 = query.getOrDefault("upload_protocol")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "upload_protocol", valid_589310
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("callback")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "callback", valid_589315
  var valid_589316 = query.getOrDefault("access_token")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "access_token", valid_589316
  var valid_589317 = query.getOrDefault("uploadType")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "uploadType", valid_589317
  var valid_589318 = query.getOrDefault("key")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "key", valid_589318
  var valid_589319 = query.getOrDefault("$.xgafv")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = newJString("1"))
  if valid_589319 != nil:
    section.add "$.xgafv", valid_589319
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

proc call*(call_589322: Call_FirebaseProjectsRemoveAnalytics_589306;
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
  ## specifying the same `analyticsPropertyId`. For Android Apps and iOS Apps,
  ## this call re-links data streams with their corresponding apps. However,
  ## for Web Apps, this call provisions a <em>new</em> data stream for each Web
  ## App.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_FirebaseProjectsRemoveAnalytics_589306;
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
  ## specifying the same `analyticsPropertyId`. For Android Apps and iOS Apps,
  ## this call re-links data streams with their corresponding apps. However,
  ## for Web Apps, this call provisions a <em>new</em> data stream for each Web
  ## App.
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
  if body != nil:
    body_589326 = body
  add(query_589325, "prettyPrint", newJBool(prettyPrint))
  result = call_589323.call(path_589324, query_589325, nil, nil, body_589326)

var firebaseProjectsRemoveAnalytics* = Call_FirebaseProjectsRemoveAnalytics_589306(
    name: "firebaseProjectsRemoveAnalytics", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}:removeAnalytics",
    validator: validate_FirebaseProjectsRemoveAnalytics_589307, base: "/",
    url: url_FirebaseProjectsRemoveAnalytics_589308, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsSearchApps_589327 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsSearchApps_589329(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsSearchApps_589328(path: JsonNode; query: JsonNode;
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
  var valid_589330 = path.getOrDefault("parent")
  valid_589330 = validateParameter(valid_589330, JString, required = true,
                                 default = nil)
  if valid_589330 != nil:
    section.add "parent", valid_589330
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
  var valid_589331 = query.getOrDefault("upload_protocol")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "upload_protocol", valid_589331
  var valid_589332 = query.getOrDefault("fields")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "fields", valid_589332
  var valid_589333 = query.getOrDefault("pageToken")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "pageToken", valid_589333
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
  var valid_589342 = query.getOrDefault("pageSize")
  valid_589342 = validateParameter(valid_589342, JInt, required = false, default = nil)
  if valid_589342 != nil:
    section.add "pageSize", valid_589342
  var valid_589343 = query.getOrDefault("prettyPrint")
  valid_589343 = validateParameter(valid_589343, JBool, required = false,
                                 default = newJBool(true))
  if valid_589343 != nil:
    section.add "prettyPrint", valid_589343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589344: Call_FirebaseProjectsSearchApps_589327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ## 
  let valid = call_589344.validator(path, query, header, formData, body)
  let scheme = call_589344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589344.url(scheme.get, call_589344.host, call_589344.base,
                         call_589344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589344, url, valid)

proc call*(call_589345: Call_FirebaseProjectsSearchApps_589327; parent: string;
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
  var path_589346 = newJObject()
  var query_589347 = newJObject()
  add(query_589347, "upload_protocol", newJString(uploadProtocol))
  add(query_589347, "fields", newJString(fields))
  add(query_589347, "pageToken", newJString(pageToken))
  add(query_589347, "quotaUser", newJString(quotaUser))
  add(query_589347, "alt", newJString(alt))
  add(query_589347, "oauth_token", newJString(oauthToken))
  add(query_589347, "callback", newJString(callback))
  add(query_589347, "access_token", newJString(accessToken))
  add(query_589347, "uploadType", newJString(uploadType))
  add(path_589346, "parent", newJString(parent))
  add(query_589347, "key", newJString(key))
  add(query_589347, "$.xgafv", newJString(Xgafv))
  add(query_589347, "pageSize", newJInt(pageSize))
  add(query_589347, "prettyPrint", newJBool(prettyPrint))
  result = call_589345.call(path_589346, query_589347, nil, nil, nil)

var firebaseProjectsSearchApps* = Call_FirebaseProjectsSearchApps_589327(
    name: "firebaseProjectsSearchApps", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}:searchApps",
    validator: validate_FirebaseProjectsSearchApps_589328, base: "/",
    url: url_FirebaseProjectsSearchApps_589329, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAddFirebase_589348 = ref object of OpenApiRestCall_588441
proc url_FirebaseProjectsAddFirebase_589350(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_FirebaseProjectsAddFirebase_589349(path: JsonNode; query: JsonNode;
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
  var valid_589351 = path.getOrDefault("project")
  valid_589351 = validateParameter(valid_589351, JString, required = true,
                                 default = nil)
  if valid_589351 != nil:
    section.add "project", valid_589351
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

proc call*(call_589364: Call_FirebaseProjectsAddFirebase_589348; path: JsonNode;
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
  let valid = call_589364.validator(path, query, header, formData, body)
  let scheme = call_589364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589364.url(scheme.get, call_589364.host, call_589364.base,
                         call_589364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589364, url, valid)

proc call*(call_589365: Call_FirebaseProjectsAddFirebase_589348; project: string;
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
  add(query_589367, "key", newJString(key))
  add(query_589367, "$.xgafv", newJString(Xgafv))
  add(path_589366, "project", newJString(project))
  if body != nil:
    body_589368 = body
  add(query_589367, "prettyPrint", newJBool(prettyPrint))
  result = call_589365.call(path_589366, query_589367, nil, nil, body_589368)

var firebaseProjectsAddFirebase* = Call_FirebaseProjectsAddFirebase_589348(
    name: "firebaseProjectsAddFirebase", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{project}:addFirebase",
    validator: validate_FirebaseProjectsAddFirebase_589349, base: "/",
    url: url_FirebaseProjectsAddFirebase_589350, schemes: {Scheme.Https})
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
