
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Composer
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages Apache Airflow environments on Google Cloud Platform.
## 
## https://cloud.google.com/composer/
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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "composer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ComposerProjectsLocationsOperationsGet_597677 = ref object of OpenApiRestCall_597408
proc url_ComposerProjectsLocationsOperationsGet_597679(protocol: Scheme;
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

proc validate_ComposerProjectsLocationsOperationsGet_597678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_597805 = path.getOrDefault("name")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "name", valid_597805
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
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597852: Call_ComposerProjectsLocationsOperationsGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_ComposerProjectsLocationsOperationsGet_597677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## composerProjectsLocationsOperationsGet
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
  var path_597924 = newJObject()
  var query_597926 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(path_597924, "name", newJString(name))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  result = call_597923.call(path_597924, query_597926, nil, nil, nil)

var composerProjectsLocationsOperationsGet* = Call_ComposerProjectsLocationsOperationsGet_597677(
    name: "composerProjectsLocationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "composer.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ComposerProjectsLocationsOperationsGet_597678, base: "/",
    url: url_ComposerProjectsLocationsOperationsGet_597679,
    schemes: {Scheme.Https})
type
  Call_ComposerProjectsLocationsEnvironmentsPatch_597984 = ref object of OpenApiRestCall_597408
proc url_ComposerProjectsLocationsEnvironmentsPatch_597986(protocol: Scheme;
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

proc validate_ComposerProjectsLocationsEnvironmentsPatch_597985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The relative resource name of the environment to update, in the form:
  ## "projects/{projectId}/locations/{locationId}/environments/{environmentId}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597987 = path.getOrDefault("name")
  valid_597987 = validateParameter(valid_597987, JString, required = true,
                                 default = nil)
  if valid_597987 != nil:
    section.add "name", valid_597987
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
  ##             : Required. A comma-separated list of paths, relative to `Environment`, of
  ## fields to update.
  ## For example, to set the version of scikit-learn to install in the
  ## environment to 0.19.0 and to remove an existing installation of
  ## argparse, the `updateMask` parameter would include the following two
  ## `paths` values: "config.softwareConfig.pypiPackages.scikit-learn" and
  ## "config.softwareConfig.pypiPackages.argparse". The included patch
  ## environment would specify the scikit-learn version as follows:
  ## 
  ##     {
  ##       "config":{
  ##         "softwareConfig":{
  ##           "pypiPackages":{
  ##             "scikit-learn":"==0.19.0"
  ##           }
  ##         }
  ##       }
  ##     }
  ## 
  ## Note that in the above example, any existing PyPI packages
  ## other than scikit-learn and argparse will be unaffected.
  ## 
  ## Only one update type may be included in a single request's `updateMask`.
  ## For example, one cannot update both the PyPI packages and
  ## labels in the same request. However, it is possible to update multiple
  ## members of a map field simultaneously in the same request. For example,
  ## to set the labels "label1" and "label2" while clearing "label3" (assuming
  ## it already exists), one can
  ## provide the paths "labels.label1", "labels.label2", and "labels.label3"
  ## and populate the patch environment as follows:
  ## 
  ##     {
  ##       "labels":{
  ##         "label1":"new-label1-value"
  ##         "label2":"new-label2-value"
  ##       }
  ##     }
  ## 
  ## Note that in the above example, any existing labels that are not
  ## included in the `updateMask` will be unaffected.
  ## 
  ## It is also possible to replace an entire map field by providing the
  ## map field's path in the `updateMask`. The new value of the field will
  ## be that which is provided in the patch environment. For example, to
  ## delete all pre-existing user-specified PyPI packages and
  ## install botocore at version 1.7.14, the `updateMask` would contain
  ## the path "config.softwareConfig.pypiPackages", and
  ## the patch environment would be the following:
  ## 
  ##     {
  ##       "config":{
  ##         "softwareConfig":{
  ##           "pypiPackages":{
  ##             "botocore":"==1.7.14"
  ##           }
  ##         }
  ##       }
  ##     }
  ## 
  ## <strong>Note:</strong> Only the following fields can be updated:
  ## 
  ##  <table>
  ##  <tbody>
  ##  <tr>
  ##  <td><strong>Mask</strong></td>
  ##  <td><strong>Purpose</strong></td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.pypiPackages
  ##  </td>
  ##  <td>Replace all custom custom PyPI packages. If a replacement
  ##  package map is not included in `environment`, all custom
  ##  PyPI packages are cleared. It is an error to provide both this mask and a
  ##  mask specifying an individual package.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.pypiPackages.<var>packagename</var></td>
  ##  <td>Update the custom PyPI package <var>packagename</var>,
  ##  preserving other packages. To delete the package, include it in
  ##  `updateMask`, and omit the mapping for it in
  ##  `environment.config.softwareConfig.pypiPackages`. It is an error
  ##  to provide both a mask of this form and the
  ##  "config.softwareConfig.pypiPackages" mask.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>labels</td>
  ##  <td>Replace all environment labels. If a replacement labels map is not
  ##  included in `environment`, all labels are cleared. It is an error to
  ##  provide both this mask and a mask specifying one or more individual
  ##  labels.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>labels.<var>labelName</var></td>
  ##  <td>Set the label named <var>labelName</var>, while preserving other
  ##  labels. To delete the label, include it in `updateMask` and omit its
  ##  mapping in `environment.labels`. It is an error to provide both a
  ##  mask of this form and the "labels" mask.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.nodeCount</td>
  ##  <td>Horizontally scale the number of nodes in the environment. An integer
  ##  greater than or equal to 3 must be provided in the `config.nodeCount`
  ##  field.
  ##  </td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.airflowConfigOverrides</td>
  ##  <td>Replace all Apache Airflow config overrides. If a replacement config
  ##  overrides map is not included in `environment`, all config overrides
  ##  are cleared.
  ##  It is an error to provide both this mask and a mask specifying one or
  ##  more individual config overrides.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.airflowConfigOverrides.<var>section</var>-<var>name
  ##  </var></td>
  ##  <td>Override the Apache Airflow config property <var>name</var> in the
  ##  section named <var>section</var>, preserving other properties. To delete
  ##  the property override, include it in `updateMask` and omit its mapping
  ##  in `environment.config.softwareConfig.airflowConfigOverrides`.
  ##  It is an error to provide both a mask of this form and the
  ##  "config.softwareConfig.airflowConfigOverrides" mask.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.envVariables</td>
  ##  <td>Replace all environment variables. If a replacement environment
  ##  variable map is not included in `environment`, all custom environment
  ##  variables  are cleared.
  ##  It is an error to provide both this mask and a mask specifying one or
  ##  more individual environment variables.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.imageVersion</td>
  ##  <td>Upgrade the version of the environment in-place. Refer to
  ##  `SoftwareConfig.image_version` for information on how to format the new
  ##  image version. Additionally, the new image version cannot effect a version
  ##  downgrade and must match the current image version's Composer major
  ##  version and Airflow major and minor versions. Consult the
  ##  <a href="/composer/docs/concepts/versioning/composer-versions">Cloud
  ##  Composer Version List</a> for valid values.</td>
  ##  </tr>
  ##  </tbody>
  ##  </table>
  section = newJObject()
  var valid_597988 = query.getOrDefault("upload_protocol")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "upload_protocol", valid_597988
  var valid_597989 = query.getOrDefault("fields")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "fields", valid_597989
  var valid_597990 = query.getOrDefault("quotaUser")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "quotaUser", valid_597990
  var valid_597991 = query.getOrDefault("alt")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = newJString("json"))
  if valid_597991 != nil:
    section.add "alt", valid_597991
  var valid_597992 = query.getOrDefault("oauth_token")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "oauth_token", valid_597992
  var valid_597993 = query.getOrDefault("callback")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "callback", valid_597993
  var valid_597994 = query.getOrDefault("access_token")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "access_token", valid_597994
  var valid_597995 = query.getOrDefault("uploadType")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "uploadType", valid_597995
  var valid_597996 = query.getOrDefault("key")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "key", valid_597996
  var valid_597997 = query.getOrDefault("$.xgafv")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = newJString("1"))
  if valid_597997 != nil:
    section.add "$.xgafv", valid_597997
  var valid_597998 = query.getOrDefault("prettyPrint")
  valid_597998 = validateParameter(valid_597998, JBool, required = false,
                                 default = newJBool(true))
  if valid_597998 != nil:
    section.add "prettyPrint", valid_597998
  var valid_597999 = query.getOrDefault("updateMask")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "updateMask", valid_597999
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

proc call*(call_598001: Call_ComposerProjectsLocationsEnvironmentsPatch_597984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an environment.
  ## 
  let valid = call_598001.validator(path, query, header, formData, body)
  let scheme = call_598001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598001.url(scheme.get, call_598001.host, call_598001.base,
                         call_598001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598001, url, valid)

proc call*(call_598002: Call_ComposerProjectsLocationsEnvironmentsPatch_597984;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## composerProjectsLocationsEnvironmentsPatch
  ## Update an environment.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The relative resource name of the environment to update, in the form:
  ## "projects/{projectId}/locations/{locationId}/environments/{environmentId}"
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
  ##             : Required. A comma-separated list of paths, relative to `Environment`, of
  ## fields to update.
  ## For example, to set the version of scikit-learn to install in the
  ## environment to 0.19.0 and to remove an existing installation of
  ## argparse, the `updateMask` parameter would include the following two
  ## `paths` values: "config.softwareConfig.pypiPackages.scikit-learn" and
  ## "config.softwareConfig.pypiPackages.argparse". The included patch
  ## environment would specify the scikit-learn version as follows:
  ## 
  ##     {
  ##       "config":{
  ##         "softwareConfig":{
  ##           "pypiPackages":{
  ##             "scikit-learn":"==0.19.0"
  ##           }
  ##         }
  ##       }
  ##     }
  ## 
  ## Note that in the above example, any existing PyPI packages
  ## other than scikit-learn and argparse will be unaffected.
  ## 
  ## Only one update type may be included in a single request's `updateMask`.
  ## For example, one cannot update both the PyPI packages and
  ## labels in the same request. However, it is possible to update multiple
  ## members of a map field simultaneously in the same request. For example,
  ## to set the labels "label1" and "label2" while clearing "label3" (assuming
  ## it already exists), one can
  ## provide the paths "labels.label1", "labels.label2", and "labels.label3"
  ## and populate the patch environment as follows:
  ## 
  ##     {
  ##       "labels":{
  ##         "label1":"new-label1-value"
  ##         "label2":"new-label2-value"
  ##       }
  ##     }
  ## 
  ## Note that in the above example, any existing labels that are not
  ## included in the `updateMask` will be unaffected.
  ## 
  ## It is also possible to replace an entire map field by providing the
  ## map field's path in the `updateMask`. The new value of the field will
  ## be that which is provided in the patch environment. For example, to
  ## delete all pre-existing user-specified PyPI packages and
  ## install botocore at version 1.7.14, the `updateMask` would contain
  ## the path "config.softwareConfig.pypiPackages", and
  ## the patch environment would be the following:
  ## 
  ##     {
  ##       "config":{
  ##         "softwareConfig":{
  ##           "pypiPackages":{
  ##             "botocore":"==1.7.14"
  ##           }
  ##         }
  ##       }
  ##     }
  ## 
  ## <strong>Note:</strong> Only the following fields can be updated:
  ## 
  ##  <table>
  ##  <tbody>
  ##  <tr>
  ##  <td><strong>Mask</strong></td>
  ##  <td><strong>Purpose</strong></td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.pypiPackages
  ##  </td>
  ##  <td>Replace all custom custom PyPI packages. If a replacement
  ##  package map is not included in `environment`, all custom
  ##  PyPI packages are cleared. It is an error to provide both this mask and a
  ##  mask specifying an individual package.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.pypiPackages.<var>packagename</var></td>
  ##  <td>Update the custom PyPI package <var>packagename</var>,
  ##  preserving other packages. To delete the package, include it in
  ##  `updateMask`, and omit the mapping for it in
  ##  `environment.config.softwareConfig.pypiPackages`. It is an error
  ##  to provide both a mask of this form and the
  ##  "config.softwareConfig.pypiPackages" mask.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>labels</td>
  ##  <td>Replace all environment labels. If a replacement labels map is not
  ##  included in `environment`, all labels are cleared. It is an error to
  ##  provide both this mask and a mask specifying one or more individual
  ##  labels.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>labels.<var>labelName</var></td>
  ##  <td>Set the label named <var>labelName</var>, while preserving other
  ##  labels. To delete the label, include it in `updateMask` and omit its
  ##  mapping in `environment.labels`. It is an error to provide both a
  ##  mask of this form and the "labels" mask.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.nodeCount</td>
  ##  <td>Horizontally scale the number of nodes in the environment. An integer
  ##  greater than or equal to 3 must be provided in the `config.nodeCount`
  ##  field.
  ##  </td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.airflowConfigOverrides</td>
  ##  <td>Replace all Apache Airflow config overrides. If a replacement config
  ##  overrides map is not included in `environment`, all config overrides
  ##  are cleared.
  ##  It is an error to provide both this mask and a mask specifying one or
  ##  more individual config overrides.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.airflowConfigOverrides.<var>section</var>-<var>name
  ##  </var></td>
  ##  <td>Override the Apache Airflow config property <var>name</var> in the
  ##  section named <var>section</var>, preserving other properties. To delete
  ##  the property override, include it in `updateMask` and omit its mapping
  ##  in `environment.config.softwareConfig.airflowConfigOverrides`.
  ##  It is an error to provide both a mask of this form and the
  ##  "config.softwareConfig.airflowConfigOverrides" mask.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.envVariables</td>
  ##  <td>Replace all environment variables. If a replacement environment
  ##  variable map is not included in `environment`, all custom environment
  ##  variables  are cleared.
  ##  It is an error to provide both this mask and a mask specifying one or
  ##  more individual environment variables.</td>
  ##  </tr>
  ##  <tr>
  ##  <td>config.softwareConfig.imageVersion</td>
  ##  <td>Upgrade the version of the environment in-place. Refer to
  ##  `SoftwareConfig.image_version` for information on how to format the new
  ##  image version. Additionally, the new image version cannot effect a version
  ##  downgrade and must match the current image version's Composer major
  ##  version and Airflow major and minor versions. Consult the
  ##  <a href="/composer/docs/concepts/versioning/composer-versions">Cloud
  ##  Composer Version List</a> for valid values.</td>
  ##  </tr>
  ##  </tbody>
  ##  </table>
  var path_598003 = newJObject()
  var query_598004 = newJObject()
  var body_598005 = newJObject()
  add(query_598004, "upload_protocol", newJString(uploadProtocol))
  add(query_598004, "fields", newJString(fields))
  add(query_598004, "quotaUser", newJString(quotaUser))
  add(path_598003, "name", newJString(name))
  add(query_598004, "alt", newJString(alt))
  add(query_598004, "oauth_token", newJString(oauthToken))
  add(query_598004, "callback", newJString(callback))
  add(query_598004, "access_token", newJString(accessToken))
  add(query_598004, "uploadType", newJString(uploadType))
  add(query_598004, "key", newJString(key))
  add(query_598004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598005 = body
  add(query_598004, "prettyPrint", newJBool(prettyPrint))
  add(query_598004, "updateMask", newJString(updateMask))
  result = call_598002.call(path_598003, query_598004, nil, nil, body_598005)

var composerProjectsLocationsEnvironmentsPatch* = Call_ComposerProjectsLocationsEnvironmentsPatch_597984(
    name: "composerProjectsLocationsEnvironmentsPatch",
    meth: HttpMethod.HttpPatch, host: "composer.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ComposerProjectsLocationsEnvironmentsPatch_597985,
    base: "/", url: url_ComposerProjectsLocationsEnvironmentsPatch_597986,
    schemes: {Scheme.Https})
type
  Call_ComposerProjectsLocationsOperationsDelete_597965 = ref object of OpenApiRestCall_597408
proc url_ComposerProjectsLocationsOperationsDelete_597967(protocol: Scheme;
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

proc validate_ComposerProjectsLocationsOperationsDelete_597966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597968 = path.getOrDefault("name")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "name", valid_597968
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
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("$.xgafv")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("1"))
  if valid_597978 != nil:
    section.add "$.xgafv", valid_597978
  var valid_597979 = query.getOrDefault("prettyPrint")
  valid_597979 = validateParameter(valid_597979, JBool, required = false,
                                 default = newJBool(true))
  if valid_597979 != nil:
    section.add "prettyPrint", valid_597979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597980: Call_ComposerProjectsLocationsOperationsDelete_597965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_597980.validator(path, query, header, formData, body)
  let scheme = call_597980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597980.url(scheme.get, call_597980.host, call_597980.base,
                         call_597980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597980, url, valid)

proc call*(call_597981: Call_ComposerProjectsLocationsOperationsDelete_597965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## composerProjectsLocationsOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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
  var path_597982 = newJObject()
  var query_597983 = newJObject()
  add(query_597983, "upload_protocol", newJString(uploadProtocol))
  add(query_597983, "fields", newJString(fields))
  add(query_597983, "quotaUser", newJString(quotaUser))
  add(path_597982, "name", newJString(name))
  add(query_597983, "alt", newJString(alt))
  add(query_597983, "oauth_token", newJString(oauthToken))
  add(query_597983, "callback", newJString(callback))
  add(query_597983, "access_token", newJString(accessToken))
  add(query_597983, "uploadType", newJString(uploadType))
  add(query_597983, "key", newJString(key))
  add(query_597983, "$.xgafv", newJString(Xgafv))
  add(query_597983, "prettyPrint", newJBool(prettyPrint))
  result = call_597981.call(path_597982, query_597983, nil, nil, nil)

var composerProjectsLocationsOperationsDelete* = Call_ComposerProjectsLocationsOperationsDelete_597965(
    name: "composerProjectsLocationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "composer.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ComposerProjectsLocationsOperationsDelete_597966,
    base: "/", url: url_ComposerProjectsLocationsOperationsDelete_597967,
    schemes: {Scheme.Https})
type
  Call_ComposerProjectsLocationsOperationsList_598006 = ref object of OpenApiRestCall_597408
proc url_ComposerProjectsLocationsOperationsList_598008(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ComposerProjectsLocationsOperationsList_598007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_598009 = path.getOrDefault("name")
  valid_598009 = validateParameter(valid_598009, JString, required = true,
                                 default = nil)
  if valid_598009 != nil:
    section.add "name", valid_598009
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
  var valid_598010 = query.getOrDefault("upload_protocol")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "upload_protocol", valid_598010
  var valid_598011 = query.getOrDefault("fields")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "fields", valid_598011
  var valid_598012 = query.getOrDefault("pageToken")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "pageToken", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("oauth_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "oauth_token", valid_598015
  var valid_598016 = query.getOrDefault("callback")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "callback", valid_598016
  var valid_598017 = query.getOrDefault("access_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "access_token", valid_598017
  var valid_598018 = query.getOrDefault("uploadType")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "uploadType", valid_598018
  var valid_598019 = query.getOrDefault("key")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "key", valid_598019
  var valid_598020 = query.getOrDefault("$.xgafv")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = newJString("1"))
  if valid_598020 != nil:
    section.add "$.xgafv", valid_598020
  var valid_598021 = query.getOrDefault("pageSize")
  valid_598021 = validateParameter(valid_598021, JInt, required = false, default = nil)
  if valid_598021 != nil:
    section.add "pageSize", valid_598021
  var valid_598022 = query.getOrDefault("prettyPrint")
  valid_598022 = validateParameter(valid_598022, JBool, required = false,
                                 default = newJBool(true))
  if valid_598022 != nil:
    section.add "prettyPrint", valid_598022
  var valid_598023 = query.getOrDefault("filter")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "filter", valid_598023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598024: Call_ComposerProjectsLocationsOperationsList_598006;
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
  let valid = call_598024.validator(path, query, header, formData, body)
  let scheme = call_598024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598024.url(scheme.get, call_598024.host, call_598024.base,
                         call_598024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598024, url, valid)

proc call*(call_598025: Call_ComposerProjectsLocationsOperationsList_598006;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## composerProjectsLocationsOperationsList
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
  var path_598026 = newJObject()
  var query_598027 = newJObject()
  add(query_598027, "upload_protocol", newJString(uploadProtocol))
  add(query_598027, "fields", newJString(fields))
  add(query_598027, "pageToken", newJString(pageToken))
  add(query_598027, "quotaUser", newJString(quotaUser))
  add(path_598026, "name", newJString(name))
  add(query_598027, "alt", newJString(alt))
  add(query_598027, "oauth_token", newJString(oauthToken))
  add(query_598027, "callback", newJString(callback))
  add(query_598027, "access_token", newJString(accessToken))
  add(query_598027, "uploadType", newJString(uploadType))
  add(query_598027, "key", newJString(key))
  add(query_598027, "$.xgafv", newJString(Xgafv))
  add(query_598027, "pageSize", newJInt(pageSize))
  add(query_598027, "prettyPrint", newJBool(prettyPrint))
  add(query_598027, "filter", newJString(filter))
  result = call_598025.call(path_598026, query_598027, nil, nil, nil)

var composerProjectsLocationsOperationsList* = Call_ComposerProjectsLocationsOperationsList_598006(
    name: "composerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "composer.googleapis.com", route: "/v1beta1/{name}/operations",
    validator: validate_ComposerProjectsLocationsOperationsList_598007, base: "/",
    url: url_ComposerProjectsLocationsOperationsList_598008,
    schemes: {Scheme.Https})
type
  Call_ComposerProjectsLocationsEnvironmentsCreate_598049 = ref object of OpenApiRestCall_597408
proc url_ComposerProjectsLocationsEnvironmentsCreate_598051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/environments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComposerProjectsLocationsEnvironmentsCreate_598050(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent must be of the form
  ## "projects/{projectId}/locations/{locationId}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_598052 = path.getOrDefault("parent")
  valid_598052 = validateParameter(valid_598052, JString, required = true,
                                 default = nil)
  if valid_598052 != nil:
    section.add "parent", valid_598052
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
  var valid_598053 = query.getOrDefault("upload_protocol")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "upload_protocol", valid_598053
  var valid_598054 = query.getOrDefault("fields")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "fields", valid_598054
  var valid_598055 = query.getOrDefault("quotaUser")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "quotaUser", valid_598055
  var valid_598056 = query.getOrDefault("alt")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = newJString("json"))
  if valid_598056 != nil:
    section.add "alt", valid_598056
  var valid_598057 = query.getOrDefault("oauth_token")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "oauth_token", valid_598057
  var valid_598058 = query.getOrDefault("callback")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "callback", valid_598058
  var valid_598059 = query.getOrDefault("access_token")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "access_token", valid_598059
  var valid_598060 = query.getOrDefault("uploadType")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "uploadType", valid_598060
  var valid_598061 = query.getOrDefault("key")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "key", valid_598061
  var valid_598062 = query.getOrDefault("$.xgafv")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = newJString("1"))
  if valid_598062 != nil:
    section.add "$.xgafv", valid_598062
  var valid_598063 = query.getOrDefault("prettyPrint")
  valid_598063 = validateParameter(valid_598063, JBool, required = false,
                                 default = newJBool(true))
  if valid_598063 != nil:
    section.add "prettyPrint", valid_598063
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

proc call*(call_598065: Call_ComposerProjectsLocationsEnvironmentsCreate_598049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new environment.
  ## 
  let valid = call_598065.validator(path, query, header, formData, body)
  let scheme = call_598065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598065.url(scheme.get, call_598065.host, call_598065.base,
                         call_598065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598065, url, valid)

proc call*(call_598066: Call_ComposerProjectsLocationsEnvironmentsCreate_598049;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## composerProjectsLocationsEnvironmentsCreate
  ## Create a new environment.
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
  ##         : The parent must be of the form
  ## "projects/{projectId}/locations/{locationId}".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598067 = newJObject()
  var query_598068 = newJObject()
  var body_598069 = newJObject()
  add(query_598068, "upload_protocol", newJString(uploadProtocol))
  add(query_598068, "fields", newJString(fields))
  add(query_598068, "quotaUser", newJString(quotaUser))
  add(query_598068, "alt", newJString(alt))
  add(query_598068, "oauth_token", newJString(oauthToken))
  add(query_598068, "callback", newJString(callback))
  add(query_598068, "access_token", newJString(accessToken))
  add(query_598068, "uploadType", newJString(uploadType))
  add(path_598067, "parent", newJString(parent))
  add(query_598068, "key", newJString(key))
  add(query_598068, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598069 = body
  add(query_598068, "prettyPrint", newJBool(prettyPrint))
  result = call_598066.call(path_598067, query_598068, nil, nil, body_598069)

var composerProjectsLocationsEnvironmentsCreate* = Call_ComposerProjectsLocationsEnvironmentsCreate_598049(
    name: "composerProjectsLocationsEnvironmentsCreate",
    meth: HttpMethod.HttpPost, host: "composer.googleapis.com",
    route: "/v1beta1/{parent}/environments",
    validator: validate_ComposerProjectsLocationsEnvironmentsCreate_598050,
    base: "/", url: url_ComposerProjectsLocationsEnvironmentsCreate_598051,
    schemes: {Scheme.Https})
type
  Call_ComposerProjectsLocationsEnvironmentsList_598028 = ref object of OpenApiRestCall_597408
proc url_ComposerProjectsLocationsEnvironmentsList_598030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/environments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComposerProjectsLocationsEnvironmentsList_598029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List environments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : List environments in the given project and location, in the form:
  ## "projects/{projectId}/locations/{locationId}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_598031 = path.getOrDefault("parent")
  valid_598031 = validateParameter(valid_598031, JString, required = true,
                                 default = nil)
  if valid_598031 != nil:
    section.add "parent", valid_598031
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
  ##           : The maximum number of environments to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598032 = query.getOrDefault("upload_protocol")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "upload_protocol", valid_598032
  var valid_598033 = query.getOrDefault("fields")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "fields", valid_598033
  var valid_598034 = query.getOrDefault("pageToken")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "pageToken", valid_598034
  var valid_598035 = query.getOrDefault("quotaUser")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "quotaUser", valid_598035
  var valid_598036 = query.getOrDefault("alt")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = newJString("json"))
  if valid_598036 != nil:
    section.add "alt", valid_598036
  var valid_598037 = query.getOrDefault("oauth_token")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "oauth_token", valid_598037
  var valid_598038 = query.getOrDefault("callback")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "callback", valid_598038
  var valid_598039 = query.getOrDefault("access_token")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "access_token", valid_598039
  var valid_598040 = query.getOrDefault("uploadType")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "uploadType", valid_598040
  var valid_598041 = query.getOrDefault("key")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "key", valid_598041
  var valid_598042 = query.getOrDefault("$.xgafv")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = newJString("1"))
  if valid_598042 != nil:
    section.add "$.xgafv", valid_598042
  var valid_598043 = query.getOrDefault("pageSize")
  valid_598043 = validateParameter(valid_598043, JInt, required = false, default = nil)
  if valid_598043 != nil:
    section.add "pageSize", valid_598043
  var valid_598044 = query.getOrDefault("prettyPrint")
  valid_598044 = validateParameter(valid_598044, JBool, required = false,
                                 default = newJBool(true))
  if valid_598044 != nil:
    section.add "prettyPrint", valid_598044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598045: Call_ComposerProjectsLocationsEnvironmentsList_598028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List environments.
  ## 
  let valid = call_598045.validator(path, query, header, formData, body)
  let scheme = call_598045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598045.url(scheme.get, call_598045.host, call_598045.base,
                         call_598045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598045, url, valid)

proc call*(call_598046: Call_ComposerProjectsLocationsEnvironmentsList_598028;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## composerProjectsLocationsEnvironmentsList
  ## List environments.
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
  ##         : List environments in the given project and location, in the form:
  ## "projects/{projectId}/locations/{locationId}"
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of environments to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598047 = newJObject()
  var query_598048 = newJObject()
  add(query_598048, "upload_protocol", newJString(uploadProtocol))
  add(query_598048, "fields", newJString(fields))
  add(query_598048, "pageToken", newJString(pageToken))
  add(query_598048, "quotaUser", newJString(quotaUser))
  add(query_598048, "alt", newJString(alt))
  add(query_598048, "oauth_token", newJString(oauthToken))
  add(query_598048, "callback", newJString(callback))
  add(query_598048, "access_token", newJString(accessToken))
  add(query_598048, "uploadType", newJString(uploadType))
  add(path_598047, "parent", newJString(parent))
  add(query_598048, "key", newJString(key))
  add(query_598048, "$.xgafv", newJString(Xgafv))
  add(query_598048, "pageSize", newJInt(pageSize))
  add(query_598048, "prettyPrint", newJBool(prettyPrint))
  result = call_598046.call(path_598047, query_598048, nil, nil, nil)

var composerProjectsLocationsEnvironmentsList* = Call_ComposerProjectsLocationsEnvironmentsList_598028(
    name: "composerProjectsLocationsEnvironmentsList", meth: HttpMethod.HttpGet,
    host: "composer.googleapis.com", route: "/v1beta1/{parent}/environments",
    validator: validate_ComposerProjectsLocationsEnvironmentsList_598029,
    base: "/", url: url_ComposerProjectsLocationsEnvironmentsList_598030,
    schemes: {Scheme.Https})
type
  Call_ComposerProjectsLocationsImageVersionsList_598070 = ref object of OpenApiRestCall_597408
proc url_ComposerProjectsLocationsImageVersionsList_598072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/imageVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComposerProjectsLocationsImageVersionsList_598071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List ImageVersions for provided location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : List ImageVersions in the given project and location, in the form:
  ## "projects/{projectId}/locations/{locationId}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_598073 = path.getOrDefault("parent")
  valid_598073 = validateParameter(valid_598073, JString, required = true,
                                 default = nil)
  if valid_598073 != nil:
    section.add "parent", valid_598073
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
  ##           : The maximum number of image_versions to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598074 = query.getOrDefault("upload_protocol")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "upload_protocol", valid_598074
  var valid_598075 = query.getOrDefault("fields")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "fields", valid_598075
  var valid_598076 = query.getOrDefault("pageToken")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "pageToken", valid_598076
  var valid_598077 = query.getOrDefault("quotaUser")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "quotaUser", valid_598077
  var valid_598078 = query.getOrDefault("alt")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = newJString("json"))
  if valid_598078 != nil:
    section.add "alt", valid_598078
  var valid_598079 = query.getOrDefault("oauth_token")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "oauth_token", valid_598079
  var valid_598080 = query.getOrDefault("callback")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "callback", valid_598080
  var valid_598081 = query.getOrDefault("access_token")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "access_token", valid_598081
  var valid_598082 = query.getOrDefault("uploadType")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "uploadType", valid_598082
  var valid_598083 = query.getOrDefault("key")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "key", valid_598083
  var valid_598084 = query.getOrDefault("$.xgafv")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = newJString("1"))
  if valid_598084 != nil:
    section.add "$.xgafv", valid_598084
  var valid_598085 = query.getOrDefault("pageSize")
  valid_598085 = validateParameter(valid_598085, JInt, required = false, default = nil)
  if valid_598085 != nil:
    section.add "pageSize", valid_598085
  var valid_598086 = query.getOrDefault("prettyPrint")
  valid_598086 = validateParameter(valid_598086, JBool, required = false,
                                 default = newJBool(true))
  if valid_598086 != nil:
    section.add "prettyPrint", valid_598086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598087: Call_ComposerProjectsLocationsImageVersionsList_598070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List ImageVersions for provided location.
  ## 
  let valid = call_598087.validator(path, query, header, formData, body)
  let scheme = call_598087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598087.url(scheme.get, call_598087.host, call_598087.base,
                         call_598087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598087, url, valid)

proc call*(call_598088: Call_ComposerProjectsLocationsImageVersionsList_598070;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## composerProjectsLocationsImageVersionsList
  ## List ImageVersions for provided location.
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
  ##         : List ImageVersions in the given project and location, in the form:
  ## "projects/{projectId}/locations/{locationId}"
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of image_versions to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598089 = newJObject()
  var query_598090 = newJObject()
  add(query_598090, "upload_protocol", newJString(uploadProtocol))
  add(query_598090, "fields", newJString(fields))
  add(query_598090, "pageToken", newJString(pageToken))
  add(query_598090, "quotaUser", newJString(quotaUser))
  add(query_598090, "alt", newJString(alt))
  add(query_598090, "oauth_token", newJString(oauthToken))
  add(query_598090, "callback", newJString(callback))
  add(query_598090, "access_token", newJString(accessToken))
  add(query_598090, "uploadType", newJString(uploadType))
  add(path_598089, "parent", newJString(parent))
  add(query_598090, "key", newJString(key))
  add(query_598090, "$.xgafv", newJString(Xgafv))
  add(query_598090, "pageSize", newJInt(pageSize))
  add(query_598090, "prettyPrint", newJBool(prettyPrint))
  result = call_598088.call(path_598089, query_598090, nil, nil, nil)

var composerProjectsLocationsImageVersionsList* = Call_ComposerProjectsLocationsImageVersionsList_598070(
    name: "composerProjectsLocationsImageVersionsList", meth: HttpMethod.HttpGet,
    host: "composer.googleapis.com", route: "/v1beta1/{parent}/imageVersions",
    validator: validate_ComposerProjectsLocationsImageVersionsList_598071,
    base: "/", url: url_ComposerProjectsLocationsImageVersionsList_598072,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
